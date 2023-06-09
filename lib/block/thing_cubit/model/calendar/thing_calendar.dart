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

enum CalendarMode {
  off,
  antifreeze,
  manual,
  daily,
  weekly;

  static CalendarMode? elementAt(int? index) =>
      index != null ? values[index] : null;
}

class ThingCalendar {
  CalendarMode currentMode;
  CalendarPoint current;
  CalendarPoint? next;
  CalendarPoint antifreeze;
  CalendarPoint manual;
  CalendarPoint? additional;
  TimeOption additionalTimeOption = TimeOption.untilNextPoint;
  Map<int, CalendarPoint> daily = {};
  Map<int, CalendarPoint> weekly = {};

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

  ThingCalendar copyWithJson(Map<String, dynamic> json) {
    final currentMode = CalendarMode.elementAt(json[CalendarKey.currentMode]);
    final curr = CalendarPoint.fromNullableJson(json[CalendarKey.currentPoint]);
    final next = CalendarPoint.fromNullableJson(json[CalendarKey.nextPoint]);
    final fz = CalendarPoint.fromNullableJson(json[CalendarKey.modeAntifreeze]);
    final manual = CalendarPoint.fromNullableJson(json[CalendarKey.modeManual]);

    final daily = CalendarPoint.mapFromJson(json[CalendarKey.modeDaily]);
    final weekly = CalendarPoint.mapFromJson(json[CalendarKey.modeWeekly]);

    return ThingCalendar(
      currentMode: currentMode ?? this.currentMode,
      current: curr ?? current,
      next: next ?? this.next,
      antifreeze: fz ?? antifreeze,
      manual: manual ?? this.manual,
      daily: daily ?? this.daily,
      weekly: weekly ?? this.weekly,
    );
  }

  ThingCalendar.fromJson(Map<String, dynamic> json)
      : currentMode = CalendarMode.values[json[CalendarKey.currentMode]],
        current = CalendarPoint.fromJson(json[CalendarKey.currentPoint]!),
        next = json[CalendarKey.nextPoint] != null
            ? CalendarPoint.fromJson(json[CalendarKey.nextPoint])
            : null,
        antifreeze = CalendarPoint.fromJson(json[CalendarKey.modeAntifreeze]),
        manual = CalendarPoint.fromJson(json[CalendarKey.modeManual]) {
    for (var element in json[CalendarKey.modeDaily]) {
      CalendarPoint point = CalendarPoint.fromJson(element);
      daily[point.timeId] = point;
    }
    for (var element in json[CalendarKey.modeWeekly]) {
      CalendarPoint point = CalendarPoint.fromJson(element);
      weekly[point.timeId] = point;
    }
  }

  Map<String, dynamic> toJson() => {
        CalendarKey.currentMode: currentMode.index,
        CalendarKey.modeAntifreeze: antifreeze.toJson(),
        CalendarKey.modeManual: manual.toJson(),
        CalendarKey.additionalPoint: additional?.toJson(),
        CalendarKey.modeDaily: CalendarPoint.mapToJson(daily),
        CalendarKey.modeWeekly: CalendarPoint.mapToJson(weekly)
      };
}
