import 'package:osh_remote/block/thing_cubit/model/calendar/calendar_point.dart';
import 'package:osh_remote/utils/constants.dart';

enum CalendarMode { off, antifreeze, manual, daily, weekly }

class ThingCalendar {
  CalendarMode mode;
  CalendarPoint antifreeze;
  CalendarPoint manual;
  List<CalendarPoint> daily = [];
  List<CalendarPoint> weekly = [];

  ThingCalendar(
      {required this.mode,
      required this.antifreeze,
      required this.manual,
      required this.daily,
      required this.weekly});

  ThingCalendar.fromJson(Map<String, dynamic> json)
      : mode = CalendarMode.values[json[Constants.keyCalendarMode]],
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
        Constants.keyCalendarMode: mode,
        Constants.keyCalendarModeAntifreeze: antifreeze.toJson(),
        Constants.keyCalendarModeManual: manual.toJson(),
        Constants.keyCalendarModeDaily: CalendarPoint.listToJson(daily),
        Constants.keyCalendarModeWeekly: CalendarPoint.listToJson(weekly)
      };
}
