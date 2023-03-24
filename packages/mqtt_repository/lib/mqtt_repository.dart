import 'dart:async';
import 'dart:io';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:flutter/services.dart';
import 'package:aws_iot_api/iot-2015-05-28.dart' as AWS;

enum MqttConnectionEvent {
  onConnected,
  onDisconnected,
  onPing,
}

class MqttServerClientRepository {
  // final _region =  "us-east-1";
  // final _policyName = "OSHdev";
  // // final _policyName = "OSH_policy";
  // final _thingName = "11:11:11:11:00:00_OSHdev";
  // final _credentials = AwsClientCredentials(accessKey: "AKIAVO57NB3YRCS5QW2Y", secretKey: "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");
  // late CreateThingResponse _thing;
  // late CreateKeysAndCertificateResponse _certificateResponse;

  late final AWS.IoT _service;
  late final MqttServerClient client;

  final _eventStreamController = StreamController<MqttConnectionEvent>();

  Stream<MqttConnectionEvent> get eventStream async* {
    yield* _eventStreamController.stream;
  }

  MqttServerClientRepository(String region, AWS.AwsClientCredentials credentials, String server) {
    this._service = AWS.IoT(region: region, credentials: credentials);
    this.client = MqttServerClient(server, '');
  }

  Future<AWS.CreateKeysAndCertificateResponse> createCertificate() async {
    return await _service.createKeysAndCertificate(setAsActive: true);
  }

  Future<void> attachPolicy(String policyName, String target) async {
    await _service.attachPolicy(policyName: policyName, target: target);
  }

  Future<AWS.CreateThingResponse> createThingAndAttachPrincipal(String thingName, String principal) async {
    AWS.CreateThingResponse response = await _service.createThing(thingName: thingName);
    await _service.attachThingPrincipal(principal: principal, thingName: thingName);
    return response;
  }

  Future<MqttClientConnectionStatus?> connect(AWS.CreateKeysAndCertificateResponse certificate, String thingName) async {
    final ByteData rootCA = await rootBundle.load('assets/certs/AmazonRootCA1.pem');

    final SecurityContext context = SecurityContext.defaultContext;
    context.setClientAuthoritiesBytes(rootCA.buffer.asUint8List());
    context.useCertificateChainBytes(certificate.certificatePem!.codeUnits);
    context.usePrivateKeyBytes(certificate.keyPair!.privateKey!.codeUnits);

    client.securityContext = context;
    client.logging(on: true);
    client.keepAlivePeriod = 20;
    client.port = 8883;
    client.secure = true;
    client.autoReconnect = true;
    client.onConnected = () => _eventStreamController.add(MqttConnectionEvent.onConnected);
    client.onDisconnected = () => _eventStreamController.add(MqttConnectionEvent.onDisconnected);
    client.pongCallback = () => _eventStreamController.add(MqttConnectionEvent.onPing);
    client.logging(on: false);
    client.connectionMessage = MqttConnectMessage()
        .withClientIdentifier(thingName).startClean();

    return await client.connect();
  }

  void publish(String topic, MqttQos qos, MqttClientPayloadBuilder builder) {
    client.publishMessage(topic, qos, builder.payload!);
  }

  void subscribe(String topic, MqttQos qos) {
    client.subscribe(topic, qos);
  }
}
