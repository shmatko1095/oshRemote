part of 'mqtt_client_bloc.dart';

abstract class MqttEvent {
  const MqttEvent();
}

class MqttGetUserThings extends MqttEvent {
  final String userId;

  const MqttGetUserThings({required this.userId});
}

class _MqttConnectedEvent extends MqttEvent {
  final String thingId;

  const _MqttConnectedEvent({required this.thingId});
}

class _MqttDisconnectedEvent extends MqttEvent {
  const _MqttDisconnectedEvent();
}

class _MqttPongEvent extends MqttEvent {
  const _MqttPongEvent();
}

class MqttStartEvent extends MqttEvent {
  final String userId;

  const MqttStartEvent({required this.userId});
}

class MqttStopEvent extends MqttEvent {
  const MqttStopEvent();
}

class MqttAddDeviceEvent extends MqttEvent {
  final String sn;
  final String sc;

  const MqttAddDeviceEvent({required this.sn, required this.sc});
}

class MqttRemoveDeviceEvent extends MqttEvent {
  final String sn;

  const MqttRemoveDeviceEvent({required this.sn});
}
