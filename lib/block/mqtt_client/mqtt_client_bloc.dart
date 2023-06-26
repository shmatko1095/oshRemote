import 'dart:async';

import 'package:aws_iot_api/iot-2015-05-28.dart' as aws;
import 'package:aws_iot_repository/i_aws_iot_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:mqtt_client_repository/i_mqtt_client_repository.dart';
import 'package:osh_remote/block/mqtt_client/cert_provider.dart';
import 'package:osh_remote/block/mqtt_client/exceptions.dart';
import 'package:osh_remote/block/mqtt_client/iot_response.dart';
import 'package:osh_remote/utils/constants.dart';

part 'aws_iot_part.dart';
part 'mqtt_client_event.dart';
part 'mqtt_client_part.dart';
part 'mqtt_client_state.dart';

class MqttClientBloc extends Bloc<MqttEvent, MqttClientState> {
  MqttClientBloc()
      : super(MqttClientState(
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
  }

  late IMqttClientRepository _mqttRepository;
  late IAwsIotRepository _iotRepository;
  final thingPolicyName = "OSHdev";
  final clientPrefix = "client-";

  final _exceptionStreamController = StreamController<Exception>.broadcast();

  void setRepo(IMqttClientRepository mqtt, IAwsIotRepository iot) {
    _mqttRepository = mqtt;
    _iotRepository = iot;
  }

  @override
  Future<void> close() {
    _exceptionStreamController.close();
    return super.close();
  }

  StreamSink<Exception> get exceptionSink => _exceptionStreamController.sink;

  Stream<Exception> get exceptionStream => _exceptionStreamController.stream;
}
