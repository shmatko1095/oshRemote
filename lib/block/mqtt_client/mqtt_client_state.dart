part of 'mqtt_client_bloc.dart';

enum MqttClientConnectionStatus {
  unknown,
  connecting,
  connected,
  disconnecting,
  disconnected
}

class ThingDescriptor {
  final String awsName;
  final String sn;
  final String sc;
  final String? name;

  ThingDescriptor({required this.awsName, required this.sn,
    required this.sc, required this.name});

  @override
  bool operator ==(other) {
    if (other is ThingDescriptor) {
      return awsName == other.awsName
          && sn == other.sn
          && sc == other.sc
        && name == other.name;
    }
    return false;
  }

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
  List<ThingDescriptor> userThingsList;
  List<String> subscribedTopics;
  IotResponse iotResp;
  String groupName;
  String clientName;
  bool inProgress;

  MqttClientState copyWith({
    MqttClientConnectionStatus? connectionState,
    List<ThingDescriptor>? userThingsList,
    List<String>? subscribedTopics,
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
