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

  Future<void> _onMqttPongEvent(
      _MqttPongEvent event, Emitter<MqttClientState> emit) async {}

  Future<void> _onMqttStartInGroupRequestedEvent(
      MqttStartEvent event, Emitter<MqttClientState> emit) async {
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
    final cert = CertificateProvider.getCert();
    await _mqttRepository.connect(
      cert!.pem,
      cert.pair.privateKey,
      thingName,
      () => add(_MqttConnectedEvent(thingId: thingName)),
      () => add(const _MqttDisconnectedEvent()),
      (topic) => {},
      (topic) {},
      (topic) => {},
      () => add(const _MqttPongEvent()),
    );
  }

  Future<void> _onMqttStopInGroupRequestedEvent(
      MqttStopEvent event, Emitter<MqttClientState> emit) async {
    emit(state.copyWith(
        connectionState: MqttClientConnectionStatus.disconnecting));
    _mqttRepository.disconnect();
  }
}
