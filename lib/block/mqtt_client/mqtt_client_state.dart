part of 'mqtt_client_bloc.dart';

enum MqttClientConnectionStatus {
  unknown,
  connecting,
  connected,
  disconnecting,
  disconnected
}

class MqttClientState {
  MqttClientState(
      {required this.connectionState,
      required this.subscribedTopics,
      required this.thingId});

  MqttClientConnectionStatus connectionState;
  List<String> subscribedTopics;
  String thingId;

  MqttClientState copyWith({
    MqttClientConnectionStatus? connectionState,
    List<String>? subscribedTopics,
    String? thingId,
  }) {
    return MqttClientState(
      connectionState: connectionState ?? this.connectionState,
      subscribedTopics: subscribedTopics ?? this.subscribedTopics,
      thingId: thingId ?? this.thingId,
    );
  }
}
