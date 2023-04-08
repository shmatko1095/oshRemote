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
      required this.userThingsList,
      required this.thingGroup,
      required this.thingId});

  MqttClientConnectionStatus connectionState;
  List<String> subscribedTopics;
  List<String> userThingsList;
  String thingGroup;
  String thingId;

  MqttClientState copyWith({
    MqttClientConnectionStatus? connectionState,
    List<String>? subscribedTopics,
    List<String>? userThingsList,
    String? thingGroup,
    String? thingId,
  }) {
    return MqttClientState(
      connectionState: connectionState ?? this.connectionState,
      subscribedTopics: subscribedTopics ?? this.subscribedTopics,
      userThingsList: userThingsList ?? this.userThingsList,
      thingGroup: thingGroup ?? this.thingGroup,
      thingId: thingId ?? this.thingId,
    );
  }
}
