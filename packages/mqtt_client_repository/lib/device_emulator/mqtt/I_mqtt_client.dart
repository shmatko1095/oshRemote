abstract class IMqttClient {
  Map<String, Map<String, dynamic>>? handle(String topic, String payload);
}
