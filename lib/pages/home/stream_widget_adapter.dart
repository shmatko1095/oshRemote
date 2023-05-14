import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:osh_remote/pages/home/widget/stream_widget.dart';

class StreamWidgetAdapter {
  final Map<String, StreamWidget> _map = {};

  void updateWidgets(String jsonString) {
    Map<String, dynamic> data = jsonDecode(jsonString);

    data.forEach((key, value) {
      if (_map.containsKey(key)) {
        String stringValue = value.toString();
        _map[key]?.sink.add(stringValue);
      }
    });
  }

  void add(String key, StreamWidget widget) {
    _map.addEntries([MapEntry(key, widget)]);
  }

  List<Widget> getWidgetList() {
    return _map.entries.map((entry) => entry.value as Widget).toList();
  }

  List<String> getTopicList() {
    return _map.entries.map((entry) => entry.key).toList();
  }
}
