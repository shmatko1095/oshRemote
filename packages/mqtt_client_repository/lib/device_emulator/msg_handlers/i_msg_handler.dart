abstract class IMsgHandler {
  String get topic;

  List<MapEntry<String, String>> process(String topic, String? payload);
}
