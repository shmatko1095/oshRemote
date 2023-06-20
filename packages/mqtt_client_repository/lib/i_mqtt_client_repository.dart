import 'package:mqtt_client/mqtt_client.dart';

abstract class IMqttClientRepository {
  Future<MqttClientConnectionStatus?> connect(
      String? certificatePem,
      String? privateKey,
      String thingName,
      ConnectCallback onConnected,
      DisconnectCallback onDisconnected,
      SubscribeCallback onSubscribed,
      UnsubscribeCallback onUnsubscribed,
      SubscribeFailCallback onSubscribeFail,
      PongCallback onPong);

  void disconnect();

  void publish(String topic, MqttQos qos, MqttClientPayloadBuilder builder);

  void subscribe(String topic, MqttQos qos);

  Stream<List<MqttReceivedMessage<MqttMessage>>>? getMessagesStream();
}
