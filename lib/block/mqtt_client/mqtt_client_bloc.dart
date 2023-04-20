import 'dart:async';

import 'package:aws_iot_api/iot-2015-05-28.dart' as AWS;
import 'package:aws_iot_repository/aws_iot_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:mqtt_client_repository/mqtt_client_repository.dart';
import 'package:osh_remote/block/mqtt_client/cert_provider.dart';
import 'package:osh_remote/block/mqtt_client/exceptions.dart';
import 'package:osh_remote/block/mqtt_client/iot_response.dart';
import 'package:osh_remote/utils/constants.dart';

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
            userThingsList: [],
            groupName: "",
            clientName: "",
            inProgress: false,
            iotResp: IotResponse(inProgress: false, successful: false))) {
    on<MqttGetUserThings>(_onMqttGetUserThingsEvent);
    on<_MqttConnectedEvent>(_onMqttConnectedEvent);
    on<_MqttDisconnectedEvent>(_onMqttDisconnectedEvent);
    on<_MqttPongEvent>(_onMqttPongEvent);
    on<MqttStartEvent>(_onMqttStartInGroupRequestedEvent);
    on<MqttStopEvent>(_onMqttStopInGroupRequestedEvent);
    on<MqttAddDeviceEvent>(_onMqttAddDeviceRequestedEvent);
    on<MqttRemoveDeviceEvent>(_onMqttRemoveDeviceRequestedEvent);
    CertificateProvider.init();
  }

  final MqttClientRepository _mqttRepository;
  final AwsIotRepository _iotRepository;
  final thingPolicyName = "OSHdev";
  final clientPrefix = "client-";

  final _exceptionStreamController = StreamController<Exception>.broadcast();

  @override
  Future<void> close() {
    _exceptionStreamController.close();
    return super.close();
  }

  StreamSink<Exception> get exceptionSink => _exceptionStreamController.sink;

  Stream<Exception> get exceptionStream => _exceptionStreamController.stream;
}
