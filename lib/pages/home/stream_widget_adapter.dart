import 'package:flutter/cupertino.dart';
import 'package:osh_remote/models/mqtt_message_descriptor.dart';
import 'package:osh_remote/pages/home/widget/stream_widget.dart';

class StreamWidgetAdapter {
  final Map<MqttMessageDescriptor, StreamWidget> _map = {};

  void notifyWidget(MqttMessageDescriptor desc, String data) {
    _map[desc]?.counterSink.add(data);
  }

  void add(MqttMessageDescriptor desc, StreamWidget widget) {
    _map.addEntries([MapEntry(desc, widget)]);
  }

  List<Widget> getWidgetList() {
    return _map.entries.map((entry) => entry.value as Widget).toList();
  }

  List<MqttMessageDescriptor> getTopicList() {
    return _map.entries.map((entry) => entry.key).toList();
  }
}
