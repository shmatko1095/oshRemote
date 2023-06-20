import 'dart:async';
import 'dart:convert';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:mqtt_client_repository/i_mqtt_client_repository.dart';
import 'package:mqtt_client_repository/mqtt_broker_mock/mqtt_broker_mock.dart';
import 'package:mqtt_client_repository/mqtt_broker_mock/mqtt_server_client_mock.dart';

class MqttClientRepositoryDemo implements IMqttClientRepository {
  static const String TAG = "MqttClientRepositoryDemo: ";
  late final MqttServerClient _client;

  MqttClientRepositoryDemo(MqttBrokerMock broker) {
    _client = MqttServerClientMock(broker);
  }

  @override
  Future<MqttClientConnectionStatus?> connect(
      String? certificatePem,
      String? privateKey,
      String thingName,
      ConnectCallback onConnected,
      DisconnectCallback onDisconnected,
      SubscribeCallback onSubscribed,
      UnsubscribeCallback onUnsubscribed,
      SubscribeFailCallback onSubscribeFail,
      PongCallback onPong) async {
    _client.clientIdentifier = thingName;
    _client.keepAlivePeriod = 30;
    _client.onConnected = onConnected;
    _client.onDisconnected = onDisconnected;
    _client.onSubscribed = onSubscribed;
    _client.pongCallback = onPong;

    print(TAG + "connect, thingName: $thingName");

    return await _client.connect();
  }

  @override
  void disconnect() {
    print(TAG + "disconnect");

    _client.disconnect();
  }

  @override
  void publish(String topic, MqttQos qos, MqttClientPayloadBuilder builder) {
    String payload = utf8.decode(builder.payload!.toList());
    print(TAG + "publish topic: $topic");
    print(TAG + "publish payload: $payload");

    _client.publishMessage(topic, qos, builder.payload!);
  }

  @override
  void subscribe(String topic, MqttQos qos) {
    print(TAG + "subscribe: $topic");

    _client.subscribe(topic, qos);
  }

  @override
  Stream<List<MqttReceivedMessage<MqttMessage>>>? getMessagesStream() {
    return _client.updates;
  }
}
