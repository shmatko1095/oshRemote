import 'dart:async';

import 'package:aws_iot_repository/aws_iot_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client_repository/mqtt_client_repository.dart';
import 'package:osh_remote/models/mqtt_message_descriptor.dart';
import 'package:osh_remote/models/mqtt_message_header.dart';

part 'mqtt_client_event.dart';

part 'mqtt_client_state.dart';

class MqttClientBloc extends Bloc<MqttEvent, MqttClientState> {
  MqttClientBloc(
    MqttClientRepository mqttRepository,
    AwsIotRepository iotRepository,
  )  : _mqttRepository = mqttRepository,
        _iotRepository = iotRepository,
        super(MqttClientState(
          connectionState: MqttClientConnectionStatus.disconnected,
          subscribedTopics: [],
          thingGroup: "",
          thingId: "",
        )) {
    on<MqttConnectRequested>(_onMqttConnectRequested);
    on<MqttConnectedEvent>(_onMqttConnectedEvent);
    on<MqttDisconnectedEvent>(_onMqttDisconnectedEvent);
    on<MqttSubscribedEvent>(_onMqttSubscribedEvent);
    on<MqttSubscribeFailEvent>(_onMqttSubscribeFailEvent);
    on<MqttSubscribeRequestedEvent>(_onMqttSubscribeRequestedEvent);
    on<MqttReceivedMessageEvent>(_onMqttReceivedMessageEvent);
    on<MqttPongEvent>(_onMqttPongEvent);
    on<MqttCreateThingGroupRequestedEvent>(_onMqttCreateThingGroupRequestedEvent);
  }

  final MqttClientRepository _mqttRepository;
  final AwsIotRepository _iotRepository;

  late StreamSubscription<List<MqttReceivedMessage<MqttMessage>>>
      _receivedMqttMessage;
  final _mqttMessageStreamController =
      StreamController<MqttMessageDescriptor>();

  @override
  Future<void> close() {
    _receivedMqttMessage.cancel();
    _mqttMessageStreamController.close();
    return super.close();
  }

  Stream<MqttMessageDescriptor> get mqttMessageStream {
    return _mqttMessageStreamController.stream;
  }

  Future<void> _onMqttConnectRequested(
      MqttConnectRequested event, Emitter<MqttClientState> emit) async {
    emit(
        state.copyWith(connectionState: MqttClientConnectionStatus.connecting));
    const policyName = "OSHdev";

    try {
      final cert = await _iotRepository.createCertificate();
      await _iotRepository.attachPolicy(policyName, cert.certificateArn!);
      await _iotRepository.createThingAndAttachPrincipal(
          event.thingId, cert.certificateArn!);
      await _mqttRepository.connect(
        cert.certificatePem!,
        cert.keyPair!.privateKey!,
        event.thingId,
        () => add(MqttConnectedEvent(thingId: event.thingId)),
        () => add(const MqttDisconnectedEvent()),
        (topic) => add(MqttSubscribedEvent(topic: topic)),
        (topic) => add(MqttSubscribeFailEvent(topic: topic)),
        () => add(const MqttPongEvent()),
      );
    } on Exception catch (e) {
      emit(state.copyWith(
          connectionState: MqttClientConnectionStatus.disconnected));
      print(e);
    }
  }

  Future<void> _onMqttConnectedEvent(
      MqttConnectedEvent event, Emitter<MqttClientState> emit) async {
    emit(state.copyWith(
        connectionState: MqttClientConnectionStatus.connected,
        thingId: event.thingId));
    await _iotRepository.addThingToThingGroup(state.thingGroup, event.thingId);
  }

  Future<void> _onMqttDisconnectedEvent(
      MqttDisconnectedEvent event, Emitter<MqttClientState> emit) async {
    emit(state.copyWith(
        connectionState: MqttClientConnectionStatus.disconnected));
  }

  Future<void> _onMqttSubscribedEvent(
      MqttSubscribedEvent event, Emitter<MqttClientState> emit) async {
    if (_mqttRepository.getMessagesStream() != null) {
      _receivedMqttMessage = _mqttRepository
          .getMessagesStream()!
          .listen((msg) => add(MqttReceivedMessageEvent(msg)));

      state.subscribedTopics.add(event.topic);
      emit(state);
    }
  }

  Future<void> _onMqttSubscribeFailEvent(
      MqttSubscribeFailEvent event, Emitter<MqttClientState> emit) async {}

  Future<void> _onMqttSubscribeRequestedEvent(
      MqttSubscribeRequestedEvent event, Emitter<MqttClientState> emit) async {
    final topic = "${state.thingId}/${event.desc.topic}";
    _mqttRepository.subscribe(topic, MqttQos.values[event.desc.qos]);
  }

  Future<void> _onMqttPongEvent(
      MqttPongEvent event, Emitter<MqttClientState> emit) async {}

  Future<void> _onMqttReceivedMessageEvent(
      MqttReceivedMessageEvent event, Emitter<MqttClientState> emit) async {
    for (var element in event.data) {
      final msg = element.payload as MqttPublishMessage;
      final String message =
          MqttPublishPayload.bytesToStringAsString(msg.payload.message);

      final topicIndex = state.thingId.length + "/".length;
      final header = MqttMessageHeader(element.topic.substring(topicIndex));
      final descriptor = MqttMessageDescriptor(message, header);
      _mqttMessageStreamController.add(descriptor);
    }
  }

  Future<void> _onMqttCreateThingGroupRequestedEvent(MqttCreateThingGroupRequestedEvent event, Emitter<MqttClientState> emit) async {
    String? name = await _iotRepository.createThingGroup(event.groupName);
    emit(state.copyWith(thingGroup: name));
  }

}
