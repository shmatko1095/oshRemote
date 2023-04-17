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
      required this.clientName,
      required this.inProgress,
      required this.iotResp});

  MqttClientConnectionStatus connectionState;
  List<String> subscribedTopics;
  List<String> userThingsList;
  IotResponse iotResp;
  String groupName;
  String clientName;
  bool inProgress;

  MqttClientState copyWith({
    MqttClientConnectionStatus? connectionState,
    List<String>? subscribedTopics,
    List<String>? userThingsList,
    String? groupName,
    String? clientName,
    IotResponse? iotResp,
    List<bool>? inProgress,
  }) {
    return MqttClientState(
      connectionState: connectionState ?? this.connectionState,
      subscribedTopics: subscribedTopics ?? this.subscribedTopics,
      userThingsList: userThingsList ?? this.userThingsList,
      groupName: groupName ?? this.groupName,
      clientName: clientName ?? this.clientName,
      iotResp: iotResp ?? this.iotResp,
      inProgress: inProgress?.first ?? this.inProgress,
    );
  }
}
