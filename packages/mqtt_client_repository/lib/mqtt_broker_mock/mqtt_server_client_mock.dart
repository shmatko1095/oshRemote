import 'dart:async';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:mqtt_client_repository/mqtt_broker_mock/mqtt_broker_mock.dart';
import 'package:typed_data/typed_data.dart';

class MqttServerClientMock extends MqttServerClient {
  Future? _onConnectTask;
  Timer? _onPongTask;
  static const _connectDelay = Duration(microseconds: 1000);

  @override
  set keepAlivePeriod(int val) => keepAliveDuration = Duration(seconds: val);

  final MqttBrokerMock _broker;

  // final _in = StreamController<MapEntry<String, MqttMessage>>.broadcast();
  final _in = StreamController<MqttPublishMessage>.broadcast();
  final _out =
      StreamController<List<MqttReceivedMessage<MqttMessage>>>.broadcast();

  late String clientIdentifier;
  late Duration keepAliveDuration;
  @override
  ConnectCallback? onConnected;
  @override
  DisconnectCallback? onDisconnected;
  @override
  SubscribeCallback? onSubscribed;
  @override
  PongCallback? pongCallback;

  int _publishCnt = 0;

  Stream<List<MqttReceivedMessage<MqttMessage>>> get updates => _out.stream;

  // StreamSink<MapEntry<String, MqttMessage>> get sink => _in.sink;
  StreamSink<MqttPublishMessage> get sink => _in.sink;

  MqttServerClientMock(this._broker) : super('', '');

  @override
  Future<MqttClientConnectionStatus?> connect(
      [String? username, String? password]) async {
    _onConnectTask = Future.delayed(_connectDelay, () {
      _broker.connect(this);
      if (onConnected != null) onConnected!();
    });

    _onPongTask = Timer.periodic(keepAliveDuration, (timer) {
      if (pongCallback != null) pongCallback!();
    });

    _in.stream.listen((inMsg) {
      _out.sink.add([
        MqttReceivedMessage<MqttMessage>(inMsg.variableHeader!.topicName, inMsg)
      ]);
    });
    return MqttClientConnectionStatus()..state = MqttConnectionState.connecting;
  }

  @override
  void disconnect() {
    _onPongTask?.cancel();
    _onConnectTask?.ignore();
    _broker.disconnect(this);
    if (onDisconnected != null) onDisconnected!();
  }

  @override
  int publishMessage(String topic, MqttQos qualityOfService, Uint8Buffer data,
      {bool retain = false}) {
    final msg = MqttPublishMessage()
        .toTopic(topic.toString())
        .withMessageIdentifier(_publishCnt)
        .withQos(qualityOfService)
        .publishData(data);

    _broker.publish(msg);
    return _publishCnt++;
  }

  @override
  Subscription? subscribe(String topic, MqttQos qosLevel) {
    _broker.subscribe(this, topic);
    if (onSubscribed != null) onSubscribed!(topic);
    return Subscription();
  }
}
