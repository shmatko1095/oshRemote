import 'I_mqtt_client.dart';

abstract class IMqttService {
  void subscribe(String topic, IMqttClient client);

  void publish(String topic, String payload);
}
