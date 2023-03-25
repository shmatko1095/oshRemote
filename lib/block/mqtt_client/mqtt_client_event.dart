part of 'mqtt_client_bloc.dart';

abstract class MqttClientEvent {
  const MqttClientEvent();
}

class AuthenticationLogoutRequested extends MqttClientEvent {}

class MqttClientConnectionEvent extends MqttClientEvent {
  final MqttConnectionEvent connectionEvent;

  const MqttClientConnectionEvent(this.connectionEvent);
}

class MqttClientConnectRequested extends MqttClientEvent {
  final String thingName;

  const MqttClientConnectRequested({required this.thingName});
}
