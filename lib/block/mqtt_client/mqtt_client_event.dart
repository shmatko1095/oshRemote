part of 'mqtt_client_bloc.dart';

abstract class MqttClientEvent {
  const MqttClientEvent();
}

class AuthenticationLogoutRequested extends MqttClientEvent {}

class MqttClientConnectionEvent extends MqttClientEvent {
  const MqttClientConnectionEvent(this.connectionEvent);

  final MqttConnectionEvent connectionEvent;
}
