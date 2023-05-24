import 'package:osh_remote/block/thing_cubit/model/calendar/calendar_point.dart';
import 'package:osh_remote/utils/constants.dart';

enum CalendarMode { off, antifreeze, manual, daily, weekly }

class ThingCalendar {
  CalendarMode currentMode;
  CalendarPoint currentPoint;
  CalendarPoint? nextPoint;
  CalendarPoint antifreeze;
  CalendarPoint manual;
  List<CalendarPoint> daily = [];
  List<CalendarPoint> weekly = [];

  ThingCalendar(
      {required this.currentMode,
      required this.currentPoint,
      required this.nextPoint,
      required this.antifreeze,
      required this.manual,
      required this.daily,
      required this.weekly});

  ThingCalendar.fromJson(Map<String, dynamic> json)
      : currentMode =
            CalendarMode.values[json[Constants.keyCalendarCurrentMode]],
        currentPoint =
            CalendarPoint.fromJson(json[Constants.keyCalendarCurrentPoint]),
        nextPoint = json[Constants.keyCalendarNextPoint] != null
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
        Constants.keyCalendarModeDaily: CalendarPoint.listToJson(daily),
        Constants.keyCalendarModeWeekly: CalendarPoint.listToJson(weekly)
      };
}
