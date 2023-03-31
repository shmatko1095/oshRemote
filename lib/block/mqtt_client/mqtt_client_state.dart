part of 'mqtt_client_bloc.dart';

// enum MqttClientStatus { initial, loading, success, failure }
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
      required this.thingName});

  MqttClientConnectionStatus connectionState;
  List<String> subscribedTopics;
  String thingName;

  MqttClientState copyWith({
    MqttClientConnectionStatus? connectionState,
    List<String>? subscribedTopics,
    String? thingName,
  }) {
    return MqttClientState(
        connectionState: connectionState ?? this.connectionState,
        subscribedTopics: subscribedTopics ?? this.subscribedTopics,
        thingName: thingName ?? this.thingName);
  }
}
