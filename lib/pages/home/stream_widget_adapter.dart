import 'package:flutter/cupertino.dart';
import 'package:osh_remote/models/mqtt_message_header.dart';
import 'package:osh_remote/pages/home/widget/stream_widget.dart';

class StreamWidgetAdapter {
  final Map<MqttMessageHeader, StreamWidget> _map = {};

  void notifyWidget(MqttMessageHeader desc, String data) {
    _map.forEach((key, value) {
      if (key.topic == desc.topic) {
        value.counterSink.add(data);
      }
    });
  }

  void add(MqttMessageHeader desc, StreamWidget widget) {
    _map.addEntries([MapEntry(desc, widget)]);
  }

  List<Widget> getWidgetList() {
    return _map.entries.map((entry) => entry.value as Widget).toList();
  }

  List<MqttMessageHeader> getTopicList() {
    return _map.entries.map((entry) => entry.key).toList();
  }
}
