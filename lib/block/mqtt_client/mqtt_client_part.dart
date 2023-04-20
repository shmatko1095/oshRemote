part of 'mqtt_client_bloc.dart';

extension MqttClientPart on MqttClientBloc {
  Future<void> _onMqttConnectedEvent(
      _MqttConnectedEvent event, Emitter<MqttClientState> emit) async {
    emit(state.copyWith(
        connectionState: MqttClientConnectionStatus.connected,
        clientName: event.thingId));
  }

  Future<void> _onMqttDisconnectedEvent(
      _MqttDisconnectedEvent event, Emitter<MqttClientState> emit) async {
    emit(state.copyWith(
        connectionState: MqttClientConnectionStatus.disconnected));
  }

  Future<void> _onMqttSubscribedEvent(
      _MqttSubscribedEvent event, Emitter<MqttClientState> emit) async {
    if (_mqttRepository.getMessagesStream() != null) {
      _receivedMqttMessage = _mqttRepository
          .getMessagesStream()!
          .listen((msg) => add(MqttReceivedMessageEvent(msg)));

      state.subscribedTopics.add(event.topic);
      emit(state);
    }
  }

  Future<void> _onMqttSubscribeFailEvent(
      _MqttSubscribeFailEvent event, Emitter<MqttClientState> emit) async {}

  Future<void> _onMqttSubscribeRequestedEvent(
      MqttSubscribeRequestedEvent event, Emitter<MqttClientState> emit) async {
    final topic = "${state.clientName}/${event.desc.topic}";
    _mqttRepository.subscribe(topic, MqttQos.values[event.desc.qos]);
  }

  Future<void> _onMqttPongEvent(
      _MqttPongEvent event, Emitter<MqttClientState> emit) async {}

  Future<void> _onMqttReceivedMessageEvent(
      MqttReceivedMessageEvent event, Emitter<MqttClientState> emit) async {
    for (var element in event.data) {
      final msg = element.payload as MqttPublishMessage;
      final String message =
          MqttPublishPayload.bytesToStringAsString(msg.payload.message);

      final topicIndex = state.clientName.length + "/".length;
      final header = MqttMessageHeader(element.topic.substring(topicIndex));
      final descriptor = MqttMessageDescriptor(message, header);
      _mqttMessageStreamController.add(descriptor);
    }
  }

  Future<void> _onMqttStartInGroupRequestedEvent(
      MqttStartRequestedEvent event, Emitter<MqttClientState> emit) async {
    final clientThingName = clientPrefix + event.userId;
    String? clientName = await _checkOrCreateThing(clientThingName);
    await _checkOrCreateCertificateWithPolicyAndAttachToThing(clientThingName);
    String? groupName = await _checkOrCreateGroup(event.userId);
    await _checkOrAddThingToGroup(groupName!, clientName!);

    emit(state.copyWith(
        groupName: groupName,
        clientName: clientName,
        connectionState: MqttClientConnectionStatus.connecting));
    _connectClient(clientThingName);
  }

  Future<void> _connectClient(String thingName) async {
    await _mqttRepository.connect(
      clientCert!.certificatePem!,
      clientCert!.keyPair!.privateKey!,
      thingName,
      () => add(_MqttConnectedEvent(thingId: thingName)),
      () => add(const _MqttDisconnectedEvent()),
      (topic) => add(_MqttSubscribedEvent(topic: topic)),
      (topic) => add(_MqttSubscribeFailEvent(topic: topic)),
      () => add(const _MqttPongEvent()),
    );
  }

  Future<void> _onMqttStopInGroupRequestedEvent(
      MqttStopRequestedEvent event, Emitter<MqttClientState> emit) async {
    emit(state.copyWith(
        connectionState: MqttClientConnectionStatus.disconnecting));
    _mqttRepository.disconnect();
  }
}
