import 'dart:async';
import 'dart:io';

import 'package:aws_iot_api/iot-2015-05-28.dart' as AWS;
import 'package:flutter/services.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttServerClientRepository {
  late final AWS.IoT _service;
  late final MqttServerClient _client;

  MqttServerClientRepository(
      String region, AWS.AwsClientCredentials credentials, String server) {
    _service = AWS.IoT(region: region, credentials: credentials);
    _client = MqttServerClient(server, '');
  }

  Future<AWS.CreateKeysAndCertificateResponse> createCertificate() async {
    return await _service.createKeysAndCertificate(setAsActive: true);
  }

  Future<void> attachPolicy(String policyName, String target) async {
    return await _service.attachPolicy(policyName: policyName, target: target);
  }

  Future<AWS.CreateThingResponse> createThingAndAttachPrincipal(
      String thingName, String principal) async {
    AWS.CreateThingResponse response =
        await _service.createThing(thingName: thingName);
    await _service.attachThingPrincipal(
        principal: principal, thingName: thingName);
    return response;
  }

  Future<MqttClientConnectionStatus?> connect(
      AWS.CreateKeysAndCertificateResponse certificate,
      ByteData rootCA,
      String thingName,
      ConnectCallback onConnected,
      DisconnectCallback onDisconnected,
      SubscribeCallback onSubscribed,
      SubscribeFailCallback onSubscribeFail,
      PongCallback onPong) async {
    final SecurityContext context = SecurityContext.defaultContext;
    context.setClientAuthoritiesBytes(rootCA.buffer.asUint8List());
    context.useCertificateChainBytes(certificate.certificatePem!.codeUnits);
    context.usePrivateKeyBytes(certificate.keyPair!.privateKey!.codeUnits);

    _client.securityContext = context;
    _client.logging(on: true);
    _client.keepAlivePeriod = 30;
    _client.port = 8883;
    _client.secure = true;
    _client.autoReconnect = true;
    _client.onConnected = onConnected;
    _client.onDisconnected = onDisconnected;
    _client.onSubscribed = onSubscribed;
    _client.onSubscribeFail = onSubscribeFail;
    _client.pongCallback = onPong;
    _client.setProtocolV311();

    _client.connectionMessage =
        MqttConnectMessage().withClientIdentifier(thingName).startClean();

    return await _client.connect();
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
