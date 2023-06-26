import 'dart:convert';

import 'package:mqtt_client_repository/device_emulator/app/calendar/calendar_point.dart';
import 'package:mqtt_client_repository/device_emulator/app/calendar/json_constants.dart';
import 'package:mqtt_client_repository/device_emulator/app/calendar/thing_calendar.dart';
import 'package:mqtt_client_repository/device_emulator/constants.dart';
import 'package:mqtt_client_repository/device_emulator/mqtt/I_mqtt_client.dart';
import 'package:mqtt_client_repository/device_emulator/mqtt/i_mqtt_service.dart';

class Calendar implements IMqttClient {
  final IMqttService _mqttService;
  late ThingCalendar _calendar;

  Calendar({required IMqttService mqttService}) : _mqttService = mqttService {
    _calendar = ThingCalendar(
        currentMode: CalendarMode.off,
        antifreeze: CalendarPoint(value: 15, power: 3),
        manual: CalendarPoint(value: 22.5, power: 5),
        daily: [],
        weekly: []);
  }

  void init() {
    _mqttService.subscribe(PublicMqttTopics.connect, this);
    _mqttService.subscribe(PublicMqttTopics.calendar, this);
    _mqttService.subscribe(CalendarMqttTopics.update, this);
  }

  CalendarPoint get current => _calendar.current;

  @override
  Map<String, Map<String, dynamic>>? handle(String topic, String payload) {
    if (topic.endsWith(PublicMqttTopics.connect)) {
      return _handleConnect();
    } else if (topic.endsWith(CalendarMqttTopics.update)) {
      return _handleSet(payload);
    }
    return null;
  }

  Map<String, Map<String, dynamic>> _handleConnect() {
    Map<String, Map<String, dynamic>> res = {};
    res[PublicMqttTopics.calendar] = _calendar.toJson();
    return res;
  }

  Map<String, Map<String, dynamic>>? _handleSet(String payload) {
    final json = jsonDecode(payload);
    _calendar = _calendar.copyWithJson(json);

    Map<String, Map<String, dynamic>> res = {};
    res[PublicMqttTopics.calendar] = _calendar.toJson();
    return res;
  }
}
