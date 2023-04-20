import 'dart:async';

import 'package:aws_iot_api/iot-2015-05-28.dart' as AWS;
import 'package:aws_iot_repository/aws_iot_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client_repository/mqtt_client_repository.dart';
import 'package:osh_remote/block/mqtt_client/exceptions.dart';
import 'package:osh_remote/block/mqtt_client/iot_response.dart';
import 'package:osh_remote/models/mqtt_message_descriptor.dart';
import 'package:osh_remote/models/mqtt_message_header.dart';
import 'package:osh_remote/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'aws_iot_part.dart';
part 'mqtt_client_event.dart';
part 'mqtt_client_part.dart';
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
    on<MqttRemoveDeviceRequestedEvent>(_onMqttRemoveDeviceRequestedEvent);
    on<MqttRenameDeviceRequestedEvent>(_onMqttRenameDeviceRequestedEvent);

    SharedPreferences.getInstance().then((value) => _prefs = value);
  }

  late final SharedPreferences _prefs;
  final MqttClientRepository _mqttRepository;
  final AwsIotRepository _iotRepository;
  final thingPolicyName = "OSHdev";
  final clientPrefix = "client-";

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
}
