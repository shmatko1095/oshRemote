import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client_repository/mqtt_broker_mock/mqtt_server_client_mock.dart';

class MqttBrokerMock {
  Map<String, MqttServerClientMock> binder = {};

  String _getSN(String topic) => topic.split("/").first;

  void publish(MqttPublishMessage message) {
    final topic = message.variableHeader!.topicName;
    binder.forEach((key, value) {
      if (_getSN(key) == _getSN(topic)) {
        value.sink?.add(message);
      }
    });
  }

  void subscribe(MqttServerClientMock instance, String topic) {
    binder[topic] = instance;
  }

  void connect(MqttServerClientMock instance) => {};

  void disconnect(MqttServerClientMock instance) =>
      binder.removeWhere((key, value) => value == instance);

  bool isConnected(MqttServerClientMock instance) =>
      binder.containsValue(instance);
}
