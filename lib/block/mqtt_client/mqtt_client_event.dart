part of 'mqtt_client_bloc.dart';

abstract class MqttEvent {
  const MqttEvent();
}

class MqttGetUserThingsRequested extends MqttEvent {
  final String userId;

  const MqttGetUserThingsRequested({required this.userId});
}

class _MqttConnectedEvent extends MqttEvent {
  final String thingId;

  const _MqttConnectedEvent({required this.thingId});
}

class _MqttDisconnectedEvent extends MqttEvent {
  const _MqttDisconnectedEvent();
}

class MqttSubscribeRequestedEvent extends MqttEvent {
  final MqttMessageHeader desc;

  const MqttSubscribeRequestedEvent({required this.desc});
}

class _MqttSubscribedEvent extends MqttEvent {
  final String topic;

  const _MqttSubscribedEvent({required this.topic});
}

class _MqttUnsubscribedEvent extends MqttEvent {
  final String topic;

  const _MqttUnsubscribedEvent({required this.topic});
}

class _MqttSubscribeFailEvent extends MqttEvent {
  final String topic;

  const _MqttSubscribeFailEvent({required this.topic});
}

class _MqttPongEvent extends MqttEvent {
  const _MqttPongEvent();
}

class MqttReceivedMessageEvent extends MqttEvent {
  final List<MqttReceivedMessage<MqttMessage>> data;

  const MqttReceivedMessageEvent(this.data);
}

class MqttStartRequestedEvent extends MqttEvent {
  final String userId;

  const MqttStartRequestedEvent({required this.userId});
}

class MqttStopRequestedEvent extends MqttEvent {
  const MqttStopRequestedEvent();
}

class MqttAddDeviceRequestedEvent extends MqttEvent {
  final String sn;
  final String sc;

  const MqttAddDeviceRequestedEvent({required this.sn, required this.sc});
}

class MqttRemoveDeviceRequestedEvent extends MqttEvent {
  final String sn;

  const MqttRemoveDeviceRequestedEvent({required this.sn});
}

class MqttRenameDeviceRequestedEvent extends MqttEvent {
  final String sn;
  final String? name;

  const MqttRenameDeviceRequestedEvent({required this.sn, required this.name});
}
