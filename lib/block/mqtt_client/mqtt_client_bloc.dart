import 'dart:async';

import 'package:aws_iot_api/iot-2015-05-28.dart' as AWS;
import 'package:aws_iot_repository/aws_iot_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client_repository/mqtt_client_repository.dart';
import 'package:osh_remote/block/mqtt_client/exeptions.dart';
import 'package:osh_remote/block/mqtt_client/iot_response.dart';
import 'package:osh_remote/models/mqtt_message_descriptor.dart';
import 'package:osh_remote/models/mqtt_message_header.dart';
import 'package:osh_remote/utils/constants.dart';

part 'mqtt_client_event.dart';

part 'mqtt_client_state.dart';

class MqttClientBloc extends Bloc<MqttEvent, MqttClientState> {
  MqttClientBloc(
    MqttClientRepository mqttRepository,
    AwsIotRepository iotRepository,
  )   : _mqttRepository = mqttRepository,
        _iotRepository = iotRepository,
        super(MqttClientState(
            connectionState: MqttClientConnectionStatus.disconnected,
            subscribedTopics: [],
            userThingsList: [],
            groupName: "",
            clientName: "",
            inProgress: false,
            iotResp: IotResponse(inProgress: false, successful: false))) {
    on<MqttGetUserThingsRequested>(_onMqttGetUserThingsEvent);
    on<_MqttConnectedEvent>(_onMqttConnectedEvent);
    on<_MqttDisconnectedEvent>(_onMqttDisconnectedEvent);
    on<_MqttSubscribedEvent>(_onMqttSubscribedEvent);
    on<_MqttSubscribeFailEvent>(_onMqttSubscribeFailEvent);
    on<MqttSubscribeRequestedEvent>(_onMqttSubscribeRequestedEvent);
    on<MqttReceivedMessageEvent>(_onMqttReceivedMessageEvent);
    on<_MqttPongEvent>(_onMqttPongEvent);
    on<MqttStartRequestedEvent>(_onMqttStartInGroupRequestedEvent);
    on<MqttStopRequestedEvent>(_onMqttStopInGroupRequestedEvent);
    on<MqttAddDeviceRequestedEvent>(_onMqttAddDeviceRequestedEvent);
  }

  final MqttClientRepository _mqttRepository;
  final AwsIotRepository _iotRepository;
  static const _thingGroupPolicyName = "OshGroupPolicy";
  static const _thingPolicyName = "OSHdev";
  static const _clientPrefix = "client-";

  AWS.CreateKeysAndCertificateResponse? clientCert;

  late StreamSubscription<List<MqttReceivedMessage<MqttMessage>>>
      _receivedMqttMessage;
  final _mqttMessageStreamController =
      StreamController<MqttMessageDescriptor>.broadcast();

  final _exceptionStreamController = StreamController<Exception>.broadcast();

  @override
  Future<void> close() {
    _receivedMqttMessage.cancel();
    _exceptionStreamController.close();
    _mqttMessageStreamController.close();
    return super.close();
  }

  Stream<MqttMessageDescriptor> get mqttMessageStream =>
      _mqttMessageStreamController.stream;

  Stream<Exception> get exceptionStream => _exceptionStreamController.stream;

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
    final clientThingName = _clientPrefix + event.userId;
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

  Future<void> _onMqttGetUserThingsEvent(
      MqttGetUserThingsRequested event, Emitter<MqttClientState> emit) async {
    final things = await _iotRepository.listThingsInGroup(event.userId);
    final devices = things.where((s) => !s.startsWith(_clientPrefix)).toList();
    emit(state.copyWith(userThingsList: devices));
  }

  Future<String?> _checkOrCreateGroup(String groupName) async {
    bool exist = await _iotRepository.isGroupExist(groupName);
    String? name =
        exist ? groupName : await _iotRepository.createGroup(groupName);
    return name;
  }

  Future<String?> _checkOrCreateThing(String thingName) async {
    bool exist = await _iotRepository.isThingExist(thingName);
    String? name;
    if (exist) {
      name = thingName;
    } else {
      final resp = await _iotRepository.createThing(thingName);

      name = resp.thingName;
    }
    return name;
  }

  Future<void> _checkOrAddThingToGroup(String group, String thing) async {
    final thingList = await _iotRepository.listThingsInGroup(group);
    if (!thingList.contains(thing)) {
      await _iotRepository.addThingToGroup(thingName: thing, groupName: group);
    }
  }

  Future<void> _checkOrCreateCertificateWithPolicyAndAttachToThing(
      String thingName) async {
    String? id = clientCert?.certificateId;
    bool isActive = await _iotRepository.isCertificateActive(id);
    if (!isActive) {
      clientCert = await _iotRepository.createCertificate();
      await _iotRepository.attachPolicy(
          _thingPolicyName, clientCert!.certificateArn!);
      await _iotRepository.attachThingPrincipal(
          thingName, clientCert!.certificateArn!);
    }
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

  Future<void> _onMqttAddDeviceRequestedEvent(
      MqttAddDeviceRequestedEvent event, Emitter<MqttClientState> emit) async {
    bool result = false;
    emit(state.copyWith(
        iotResp: IotResponse(inProgress: true, successful: result)));

    try {
      final things = await _iotRepository.listThingsByAttribute(
          attributeName: Constants.serialNumberKey, attributeValue: event.sn);
      if (things.things == null || things.things!.isEmpty) {
        _exceptionStreamController.add(NoIotDeviceFound());
      } else {
        final thing = things.things![0];
        String? thingSc = thing.attributes![Constants.secureCodeKey];
        if (event.sc != thingSc) {
          _exceptionStreamController.add(SecureCodeIncorrect());
        } else {
          _iotRepository.addThingToGroup(
              thingName: thing.thingName!, groupName: state.groupName);
          final userThings = state.userThingsList;
          userThings.add(thing.thingName!);
          emit(state.copyWith(userThingsList: userThings));
          result = true;
        }
      }
    } on Exception catch (e) {
      _exceptionStreamController.add(e);
    }
    emit(state.copyWith(
        iotResp: IotResponse(successful: result, inProgress: false)));
  }

/**
 * 1)createThingGroup
 * 2)check cert. If not available then:
 * 2.1)createCertificate
 * 2.2)attachPolicy(policyName, cert.certificateArn!);
 * 3)check thing. If not available then:
 * 3.1)createThing(event.thingId)
 * 3.2)attachThingPrincipal(event.thingId, cert.certificateArn!);
 * 4)connect
 **/
}
