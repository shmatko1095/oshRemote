import 'package:mqtt_client_repository/device_emulator/app/calendar/calendar_point.dart';
import 'package:mqtt_client_repository/device_emulator/app/calendar/json_constants.dart';

enum TimeOption {
  untilNextPoint,
  forHalfHour,
  goToManual,
  setupTime,
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

  // CalendarPoint? next;
  CalendarPoint antifreeze;
  CalendarPoint manual;
  CalendarPoint? additional;
  TimeOption additionalTimeOption = TimeOption.untilNextPoint;
  List<CalendarPoint> daily = [];
  List<CalendarPoint> weekly = [];

  final CalendarPoint off = CalendarPoint(value: 0, power: 0);

  dynamic get points {
    switch (currentMode) {
      case CalendarMode.off:
        return off;
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
      required this.antifreeze,
      required this.manual,
      required this.daily,
      required this.weekly});

  static ThingCalendar? fromNullableJson(Map<String, dynamic>? json) {
    return json != null ? ThingCalendar.fromJson(json) : null;
  }

  ThingCalendar copyWithJson(Map<String, dynamic> json) {
    final currentMode = CalendarMode.elementAt(json[CalendarKey.currentMode]);
    final fz = CalendarPoint.fromNullableJson(json[CalendarKey.modeAntifreeze]);
    final manual = CalendarPoint.fromNullableJson(json[CalendarKey.modeManual]);

    final daily = CalendarPoint.listFromJson(json[CalendarKey.modeDaily]);
    final weekly = CalendarPoint.listFromJson(json[CalendarKey.modeWeekly]);

    return ThingCalendar(
      currentMode: currentMode ?? this.currentMode,
      antifreeze: fz ?? antifreeze,
      manual: manual ?? this.manual,
      daily: daily ?? this.daily,
      weekly: weekly ?? this.weekly,
    );
  }

  ThingCalendar.fromJson(Map<String, dynamic> json)
      : currentMode = CalendarMode.values[json[CalendarKey.currentMode]],
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
        CalendarKey.currentMode: currentMode.index,
        CalendarKey.currentPoint: current,
        CalendarKey.modeAntifreeze: antifreeze.toJson(),
        CalendarKey.modeManual: manual.toJson(),
        CalendarKey.additionalPoint: additional?.toJson(),
        CalendarKey.modeDaily: CalendarPoint.listToJson(daily),
        CalendarKey.modeWeekly: CalendarPoint.listToJson(weekly)
      };

  CalendarPoint get current {
    final timeId = _timeIdFromDateTime(DateTime.now());
    switch (currentMode) {
      case CalendarMode.off:
        return off;
      case CalendarMode.antifreeze:
        return antifreeze;
      case CalendarMode.manual:
        return manual;
      // Fix point selection
      case CalendarMode.daily:
        return daily.lastWhere((el) => el.timeId < timeId,
            orElse: () =>
                daily.firstWhere((f) => f.timeId >= timeId, orElse: () => off));
      case CalendarMode.weekly:
        return weekly.lastWhere((el) => el.timeId < timeId,
            orElse: () => weekly.firstWhere((f) => f.timeId >= timeId,
                orElse: () => off));
    }
  }

  int _timeIdFromDateTime(DateTime time) {
    int res = 0;
    res += time.weekday * 24 * 60;
    res += time.hour * 60;
    res += time.minute;
    return res;
  }
}
