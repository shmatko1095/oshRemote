import 'dart:io';

import 'package:flutter/services.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import 'package:aws_iot_api/iot-2015-05-28.dart';

class _InitState {
  Future<void> checkSignedInAndGoToHome() async {
      await iot();
      // await IotData();
      await mqttConnect();
      // await mqttClent();
      // _setupMqttClient();
      // await _connectClient();
  }

  final _region =  "us-east-1";
  final _policyName = "OSHdev";
  // final _policyName = "OSH_policy";
  final _thingName = "11:11:11:11:00:00_OSHdev";
  final _credentials = AwsClientCredentials(accessKey: "AKIAVO57NB3YRCS5QW2Y", secretKey: "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");
  late CreateThingResponse _thing;
  late CreateKeysAndCertificateResponse _certificateResponse;

  Future<void> iot() async {
      final service = IoT(region: _region, credentials: _credentials);
      _certificateResponse = await service.createKeysAndCertificate(setAsActive: true);
      await service.attachPolicy(policyName: _policyName, target: _certificateResponse.certificateArn!);

      _thing = await service.createThing(thingName: _thingName);
      await service.attachThingPrincipal(principal: _certificateResponse.certificateArn!, thingName: _thing.thingName!);
  }

  bool isConnected = false;
  final MqttServerClient client = MqttServerClient('a3qrc8lpkkm4w-ats.iot.us-east-1.amazonaws.com', '');

  Future<bool> mqttConnect() async {
    ByteData rootCA = await rootBundle.load('assets/certs/AmazonRootCA1.pem');

    SecurityContext context = SecurityContext.defaultContext;
    context.setClientAuthoritiesBytes(rootCA.buffer.asUint8List());
    context.useCertificateChainBytes(_certificateResponse.certificatePem!.codeUnits);
    context.usePrivateKeyBytes(_certificateResponse.keyPair!.privateKey!.codeUnits);
    client.securityContext = context;


    client.logging(on: true);
    client.keepAlivePeriod = 20;
    client.port = 8883;
    client.secure = true;
    client.autoReconnect = true;
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;
    client.pongCallback = pong;
    client.logging(on: false);

    final MqttConnectMessage connMess =
    MqttConnectMessage().withClientIdentifier(_thing.thingName!).startClean(); //ClientIdentifier must ne thing name
    client.connectionMessage = connMess;

    MqttClientConnectionStatus? status = await client.connect();
    print(status);
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print("Connected to AWS Successfully!");
    } else {
      return false;
    }

    final builder = MqttClientPayloadBuilder();
    builder.addString("Hello😎");
    client.publishMessage(_thing.thingName!, MqttQos.atLeastOnce, builder.payload!);

    client.subscribe(_thing.thingName!, MqttQos.atMostOnce);
    client.updates!.listen((event) => event.forEach((element) => print("topic: ${element.topic} payload: ${element.payload.toString()}")));
    return true;
  }

  void onConnected() {
    print("Client connection was successful");
  }

  void onDisconnected() {
    isConnected = false;
  }

  void pong() {
    final builder = MqttClientPayloadBuilder();
    builder.addString("ping resp");
    client.publishMessage(_thing.thingName!, MqttQos.atLeastOnce, builder.payload!);
    print('Ping response client callback invoked');
  }

}
