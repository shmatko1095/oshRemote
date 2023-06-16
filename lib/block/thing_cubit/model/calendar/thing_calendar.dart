import 'package:osh_remote/block/thing_cubit/model/calendar/calendar_point.dart';
import 'package:osh_remote/block/thing_cubit/model/time_option.dart';

class CalendarTopic {
  static const _calendar = "calendar";
  static const set = "$_calendar/set";
  static const update = "$_calendar/update";
}

class CalendarKey {
  static const calendar = "calendar";
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

enum CalendarMode { off, antifreeze, manual, daily, weekly }

class ThingCalendar {
  CalendarMode currentMode;
  CalendarPoint current;
  CalendarPoint? next;
  CalendarPoint antifreeze;
  CalendarPoint manual;
  CalendarPoint? additional;
  TimeOption additionalTimeOption = TimeOption.untilNextPoint;
  List<CalendarPoint> daily = [];
  List<CalendarPoint> weekly = [];

  dynamic get points {
    switch (currentMode) {
      case CalendarMode.off:
        return null;
      case CalendarMode.antifreeze:
        return antifreeze;
      case CalendarMode.manual:
        return manual;
      case CalendarMode.daily:
        return daily;
      case CalendarMode.weekly:
        return weekly;
    }
  }

  ThingCalendar(
      {required this.currentMode,
      required this.current,
      required this.next,
      required this.antifreeze,
      required this.manual,
      required this.daily,
      required this.weekly});

  static ThingCalendar? fromNullableJson(Map<String, dynamic>? json) {
    return json != null ? ThingCalendar.fromJson(json) : null;
  }

  ThingCalendar.fromJson(Map<String, dynamic> json)
      : currentMode = CalendarMode.values[json[CalendarKey.currentMode]],
        current = CalendarPoint.fromJson(json[CalendarKey.currentPoint]),
        next = json[CalendarKey.nextPoint] != null
            ? CalendarPoint.fromJson(json[CalendarKey.nextPoint])
            : null,
        antifreeze = CalendarPoint.fromJson(json[CalendarKey.modeAntifreeze]),
        manual = CalendarPoint.fromJson(json[CalendarKey.modeManual]) {
    for (var element in json[CalendarKey.modeDaily]) {
      daily.add(CalendarPoint.fromJson(element));
    }
    for (var element in json[CalendarKey.modeWeekly]) {
      weekly.add(CalendarPoint.fromJson(element));
    }
  }

  Map<String, dynamic> toJson() => {
        CalendarKey.currentMode: currentMode,
        CalendarKey.modeAntifreeze: antifreeze.toJson(),
        CalendarKey.modeManual: manual.toJson(),
        CalendarKey.additionalPoint: additional?.toJson(),
        CalendarKey.modeDaily: CalendarPoint.listToJson(daily),
        CalendarKey.modeWeekly: CalendarPoint.listToJson(weekly)
      };
}
