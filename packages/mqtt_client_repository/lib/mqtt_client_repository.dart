import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:mqtt_client_repository/cert_manager.dart';

class MqttClientRepository {
  late final MqttServerClient _client;
  static MqttClientRepository? _instance;

  static MqttClientRepository createInstance(String server) {
    if (_instance == null) {
      _instance = MqttClientRepository._(server);
    } else {
      // if (server == _instance!._client.server) {
      // throw StateError("MqttClientRepository instance already exists");
      // }
    }
    return _instance!;
  }

  static MqttClientRepository getInstance() {
    if (_instance == null) {
      throw StateError("MqttClientRepository instance does not exists");
    }
    return _instance!;
  }

  MqttClientRepository._(String server) {
    _client = MqttServerClient(server, '');
  }

  Future<MqttClientConnectionStatus?> connect(
      String certificatePem,
      String privateKey,
      String thingName,
      ConnectCallback onConnected,
      DisconnectCallback onDisconnected,
      SubscribeCallback onSubscribed,
      UnsubscribeCallback onUnsubscribed,
      SubscribeFailCallback onSubscribeFail,
      PongCallback onPong) async {
    ByteData rootCA = await CertificateManager.getRootCertificate();

    final SecurityContext context = SecurityContext.defaultContext;
    context.setClientAuthoritiesBytes(rootCA.buffer.asUint8List());
    context.useCertificateChainBytes(certificatePem.codeUnits);
    context.usePrivateKeyBytes(privateKey.codeUnits);

    _client.securityContext = context;
    _client.clientIdentifier = thingName;
    _client.logging(on: false);
    _client.keepAlivePeriod = 30;
    _client.port = 8883;
    _client.secure = true;
    _client.autoReconnect = true;
    _client.onConnected = onConnected;
    _client.onDisconnected = onDisconnected;
    _client.onAutoReconnect = onDisconnected;
    _client.onAutoReconnected = onConnected;
    _client.onSubscribed = onSubscribed;
    _client.onUnsubscribed = onUnsubscribed;
    _client.onSubscribeFail = onSubscribeFail;
    _client.pongCallback = onPong;
    _client.setProtocolV311();

    return await _client.connect();
  }

  void disconnect() {
    _client.disconnect();
  }

  void publish(String topic, MqttQos qos, MqttClientPayloadBuilder builder) {
    _client.publishMessage(topic, qos, builder.payload!);
  }

  void subscribe(String topic, MqttQos qos) {
    _client.subscribe(topic, qos);
  }

  Stream<List<MqttReceivedMessage<MqttMessage>>>? getMessagesStream() {
    return _client.updates;
  }
}
