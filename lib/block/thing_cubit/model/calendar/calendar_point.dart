import 'package:osh_remote/utils/constants.dart';

enum Day { off, antifreeze, manual, daily, weekly }

class CalendarPoint {
  int? day;
  int? min;
  int? hour;
  double value;
  int? power;

  CalendarPoint(this.day, this.min, this.hour, this.value, this.power);

  CalendarPoint.fromJson(Map<String, dynamic> json)
      : day = json[Constants.keyCalendarDay],
        min = json[Constants.keyCalendarHour],
        hour = json[Constants.keyCalendarMin],
        value = json[Constants.keyCalendarValue],
        power = json[Constants.keyCalendarPower];

  Map<String, dynamic> toJson() => {
        Constants.keyCalendarDay: day,
        Constants.keyCalendarHour: min,
        Constants.keyCalendarMin: hour,
        Constants.keyCalendarValue: value,
        Constants.keyCalendarPower: power,
      };

  static List<dynamic> listToJson(List<CalendarPoint> list) {
    List<dynamic> result = [];
    for (var element in list) {
      result.add(element.toJson());
    }
    return result;
  }
}
