import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:mqtt_repository/mqtt_repository.dart';

part "mqtt_client_event.dart";
part "mqtt_client_state.dart";

class MqttClientBloc extends Bloc<MqttClientEvent, MqttClientState> {
  MqttClientBloc({required MqttServerClientRepository repository})
      : _mqttRepository = repository,
        super(const MqttClientState()) {
    on<MqttClientConnectionEvent>(_onMqttClientConnectionEvent);
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

  FutureOr<void> _onMqttClientConnectionEvent(
      MqttClientConnectionEvent event, Emitter<MqttClientState> emit) {}
}
