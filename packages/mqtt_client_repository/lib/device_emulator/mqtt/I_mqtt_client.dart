abstract class IMqttClient {
  Map<String, dynamic>? handle(String topic, String payload);
}
