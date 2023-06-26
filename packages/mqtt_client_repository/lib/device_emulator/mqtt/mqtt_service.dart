import 'dart:convert';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client_repository/device_emulator/constants.dart';
import 'package:mqtt_client_repository/device_emulator/mqtt/i_mqtt_service.dart';
import 'package:mqtt_client_repository/mqtt_broker_mock/mqtt_broker_mock.dart';
import 'package:mqtt_client_repository/mqtt_broker_mock/mqtt_server_client_mock.dart';

import 'I_mqtt_client.dart';

class MqttService implements IMqttClient, IMqttService {
  static final DEFAULT_SN = "SN00000000";
  static final TAG = "MqttService: ";

  String? _clientId;
  bool _connected = false;
  late final String _sn;
  late final MqttServerClientMock _client;
  final Map<String, List<IMqttClient>> _handlerMap = {};

  MqttService({required MqttBrokerMock broker, String? sn}) {
    _sn = sn ?? DEFAULT_SN;
    _client = MqttServerClientMock(broker);

    _client.clientIdentifier = _sn;
    _client.keepAlivePeriod = 30;
    _client.onConnected = _onConnected;
    _client.onDisconnected = () {
      _onDisconnected();
    };
    _client.onSubscribed = (topic) => print("$TAG Subscribed: $topic");
    _client.pongCallback = () => print("$TAG Ping");
  }

  void init() {
    subscribe(PublicMqttTopics.connect, this);

    _client.updates.listen((event) {
      event.forEach((element) {
        final m = element.payload as MqttPublishMessage;
        final pl = MqttPublishPayload.bytesToStringAsString(m.payload.message);
        Map<String, Map<String, dynamic>> resp = {};
        _handlerMap.forEach((key, value) {
          if (element.topic.endsWith(key)) {
            _handlerMap[key]?.forEach((client) {
              final handlerResp = client.handle(element.topic, pl);
              if (handlerResp != null) resp.addAll(handlerResp);
            });
          }
        });
        final topic = element.topic.substring(element.topic.indexOf("/") + 1);
        publish(topic, jsonEncode(resp));
      });
    });

    _client.connect();
  }

  void deInit() {
    _onDisconnected();
  }

  void _onConnected() {
    print("$TAG Connected");
    _client.subscribe("$_sn/#", MqttQos.atLeastOnce);
  }

  void _onDisconnected() {
    print("$TAG Disconnected");
    _client.disconnect();
  }

  ///Service API
  @override
  void subscribe(String topic, IMqttClient client) {
    if (_handlerMap["$_sn/$topic"] == null) {
      _handlerMap["$_sn/$topic"] = [client];
    } else {
      _handlerMap["$_sn/$topic"]!.add(client);
    }
  }

  @override
  void publish(String topic, String payload) {
    print("topic: $topic this: ${this.hashCode}");
    final builder = MqttClientPayloadBuilder();
    builder.addString(payload);

    final fullTopic = "$_clientId/$_sn/$topic";
    _client.publishMessage(fullTopic, MqttQos.atLeastOnce, builder.payload!);
  }

  ///Client API
  Map<String, dynamic> _toJson() => {
        ConfigKey.status: _connected,
        ConfigKey.clientId: _sn,
      };

  @override
  Map<String, Map<String, dynamic>>? handle(String topic, String payload) {
    final data = jsonDecode(payload);
    _clientId = data[ConfigKey.clientId];
    _connected = data[ConfigKey.status];

    Map<String, Map<String, dynamic>> res = {};
    res[ConfigKey.client] = _toJson();
    return res;
  }
}
