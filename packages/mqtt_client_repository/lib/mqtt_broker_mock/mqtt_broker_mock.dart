import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client_repository/mqtt_broker_mock/mqtt_server_client_mock.dart';

class MqttBrokerMock {
  Map<MqttServerClientMock, List<String>> binder = {};

  String _getSN(String topic) => topic.split("/").first;

  void publish(MqttPublishMessage message) {
    final topic = message.variableHeader!.topicName;
    binder.keys.forEach((key) {
      if (binder[key]?.any((el) => _getSN(el) == _getSN(topic)) ?? false) {
        key.sink.add(message);
      }
    });
  }

  void subscribe(MqttServerClientMock instance, String topic) {
    binder[instance]?.add(topic);
  }

  void connect(MqttServerClientMock instance) => binder[instance] = [];

  void disconnect(MqttServerClientMock instance) => binder.remove(instance);
}
