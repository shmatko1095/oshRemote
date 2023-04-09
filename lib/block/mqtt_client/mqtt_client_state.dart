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
      required this.groupName,
      required this.clientName});

  MqttClientConnectionStatus connectionState;
  List<String> subscribedTopics;
  List<String> userThingsList;
  String groupName;
  String clientName;

  MqttClientState copyWith({
    MqttClientConnectionStatus? connectionState,
    List<String>? subscribedTopics,
    List<String>? userThingsList,
    String? groupName,
    String? clientName,
  }) {
    return MqttClientState(
      connectionState: connectionState ?? this.connectionState,
      subscribedTopics: subscribedTopics ?? this.subscribedTopics,
      userThingsList: userThingsList ?? this.userThingsList,
      groupName: groupName ?? this.groupName,
      clientName: clientName ?? this.clientName,
    );
  }
}
