import 'package:mqtt_client_repository/device_emulator/constants.dart';

class CalendarMqttTopics {
  static const update = PublicMqttTopics.calendar + "/update";
}

class CalendarKey {
  static const currentMode = "currentMode";
  static const currentPoint = "currentPoint";
  static const additionalPoint = "additionalPoint";
  static const nextPoint = "nextPoint";
  static const modeOff = "off";
  static const modeAntifreeze = "antifreeze";
  static const modeManual = "manual";
  static const modeDaily = "daily";
  static const modeWeekly = "weekly";
  static const day = "d";
  static const hour = "h";
  static const min = "m";
  static const value = "v";
  static const power = "p";
}
