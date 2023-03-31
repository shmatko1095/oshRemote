part of 'mqtt_client_bloc.dart';

abstract class MqttEvent {
  const MqttEvent();
}

// class AuthenticationLogoutRequested extends MqttEvent {}

class MqttConnectRequested extends MqttEvent {
  final String thingName;

  const MqttConnectRequested({required this.thingName});
}

class MqttConnectedEvent extends MqttEvent {
  const MqttConnectedEvent();
}

class MqttDisconnectedEvent extends MqttEvent {
  const MqttDisconnectedEvent();
}

class MqttSubscribeRequestedEvent extends MqttEvent {
  final MqttMessageDescriptor desc;

  const MqttSubscribeRequestedEvent({required this.desc});
}

class MqttSubscribedEvent extends MqttEvent {
  final String topic;

  const MqttSubscribedEvent({required this.topic});
}

class MqttSubscribeFailEvent extends MqttEvent {
  final String topic;

  const MqttSubscribeFailEvent({required this.topic});
}

class MqttPongEvent extends MqttEvent {
  const MqttPongEvent();
}

class MqttReceivedMessageEvent extends MqttEvent {
  final List<MqttReceivedMessage<MqttMessage>> data;

  const MqttReceivedMessageEvent(this.data);
}
