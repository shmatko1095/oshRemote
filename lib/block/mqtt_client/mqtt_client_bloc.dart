import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:mqtt_repository/mqtt_repository.dart';
import 'package:aws_iot_api/iot-2015-05-28.dart' as AWS;

part "mqtt_client_event.dart";
part "mqtt_client_state.dart";

class MqttClientBloc extends Bloc<MqttClientEvent, MqttClientState> {
  MqttClientBloc({required MqttServerClientRepository repository})
      : _mqttRepository = repository,
        super(const MqttClientState()) {
    on<MqttClientConnectionEvent>(_onMqttConnectionEvent);
    on<MqttClientConnectRequested>(_onMqttConnectRequested);
    _receivedMqttEvent = _mqttRepository.eventStream
        .listen((msg) => add(MqttClientConnectionEvent(msg)));
  }

  final MqttServerClientRepository _mqttRepository;
  late StreamSubscription<MqttConnectionEvent> _receivedMqttEvent;

  @override
  Future<void> close() {
    _receivedMqttEvent.cancel();
    return super.close();
  }

  FutureOr<void> _onMqttConnectionEvent(
      MqttClientConnectionEvent event, Emitter<MqttClientState> emit) {
    print(event.connectionEvent);
  }

  Future<FutureOr<void>> _onMqttConnectRequested(
      MqttClientConnectRequested event, Emitter<MqttClientState> emit) async {
    final policyName = "OSHdev";

    try {
      AWS.CreateKeysAndCertificateResponse cert = await _mqttRepository
          .createCertificate();
      await _mqttRepository.attachPolicy(policyName, cert.certificateArn!);
      await _mqttRepository.createThingAndAttachPrincipal(
          event.thingName, cert.certificateArn!);
      await _mqttRepository.connect(cert, event.thingName);
    } on Exception catch (e) {
      print(e);
    }
  }
}
