import 'dart:convert';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client_repository/device_emulator/constants.dart';
import 'package:mqtt_client_repository/mqtt_broker_mock/mqtt_broker_mock.dart';
import 'package:mqtt_client_repository/mqtt_broker_mock/mqtt_server_client_mock.dart';

class DeviceEmulator {
  static final TAG = "DeviceEmulator: ";
  static final SN = "SN00000000";
  late final MqttServerClientMock _client;

  String? _clientId;
  bool _connected = false;

  DeviceEmulator(MqttBrokerMock broker) {
    _client = MqttServerClientMock(broker);

    _client.clientIdentifier = SN;
    _client.keepAlivePeriod = 30;
    _client.onConnected = _onConnected;
    _client.onDisconnected = _onDisconnected;
    _client.onSubscribed = (topic) => print("$TAG Subscribed: $topic");
    _client.pongCallback = () => print("$TAG Ping");

    _client.updates.listen((event) {
      event.forEach((element) {
        final m = element.payload as MqttPublishMessage;
        final pl = MqttPublishPayload.bytesToStringAsString(m.payload.message);
        _handeMsg(element.topic, pl);
      });
    });
  }

  void init() {
    _client.connect();
  }

  void _onConnected() {
    print("$TAG Connected");
    _client.subscribe("$SN/#", MqttQos.atLeastOnce);
  }

  void _onDisconnected() {
    print("$TAG Disconnected");
    _client.disconnect();
  }

  void _handeMsg(String topic, String payload) {
    print("$TAG Msg: $topic, payload: $payload");
    if (topic.endsWith(Constants.topicConnect)) {
      _handleConnect(payload);
    }
  }

  void _handleConnect(String payload) {
    final data = jsonDecode(payload);
    _clientId = data[ConfigKey.clientId];
    _connected = data[ConfigKey.status];
  }
}
