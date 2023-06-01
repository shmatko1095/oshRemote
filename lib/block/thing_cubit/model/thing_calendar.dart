import 'package:osh_remote/block/thing_cubit/model/calendar/calendar_point.dart';
import 'package:osh_remote/block/thing_cubit/model/time_option.dart';
import 'package:osh_remote/utils/constants.dart';

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

  ThingCalendar.fromJson(Map<String, dynamic> json)
      : currentMode =
            CalendarMode.values[json[Constants.keyCalendarCurrentMode]],
        current =
            CalendarPoint.fromJson(json[Constants.keyCalendarCurrentPoint]),
        next = json[Constants.keyCalendarNextPoint] != null
            ? CalendarPoint.fromJson(json[Constants.keyCalendarNextPoint])
            : null,
        antifreeze =
            CalendarPoint.fromJson(json[Constants.keyCalendarModeAntifreeze]),
        manual = CalendarPoint.fromJson(json[Constants.keyCalendarModeManual]) {
    for (var element in json[Constants.keyCalendarModeDaily]) {
      daily.add(CalendarPoint.fromJson(element));
    }
    for (var element in json[Constants.keyCalendarModeWeekly]) {
      weekly.add(CalendarPoint.fromJson(element));
    }
  }

  Map<String, dynamic> toJson() => {
        Constants.keyCalendarCurrentMode: currentMode,
        Constants.keyCalendarModeAntifreeze: antifreeze.toJson(),
        Constants.keyCalendarModeManual: manual.toJson(),
        Constants.keyCalendarAdditionalPoint: additional?.toJson(),
        Constants.keyCalendarModeDaily: CalendarPoint.listToJson(daily),
        Constants.keyCalendarModeWeekly: CalendarPoint.listToJson(weekly)
      };
}
