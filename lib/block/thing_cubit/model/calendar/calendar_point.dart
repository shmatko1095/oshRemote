import 'package:osh_remote/block/thing_cubit/model/thing_calendar.dart';

enum Day { off, antifreeze, manual, daily, weekly }

class CalendarPoint implements Comparable<CalendarPoint> {
  int? day;
  int? min;
  int? hour;
  double value;
  int? power;

  int get timeId {
    int res = 0;
    res += day != null ? day! * 24 * 60 : 0;
    res += hour != null ? hour! * 60 : 0;
    res += min != null ? min! : 0;
    return res;
  }

  CalendarPoint(
      {this.day, this.min, this.hour, required this.value, this.power});

  CalendarPoint.fromJson(Map<String, dynamic> json)
      : day = json[CalendarKey.day],
        hour = json[CalendarKey.hour],
        min = json[CalendarKey.min],
        value = json[CalendarKey.value],
        power = json[CalendarKey.power];

  Map<String, dynamic> toJson() => {
        CalendarKey.day: day,
        CalendarKey.hour: hour,
        CalendarKey.min: min,
        CalendarKey.value: value,
        CalendarKey.power: power,
      };

  static List<dynamic> listToJson(List<CalendarPoint> list) {
    List<dynamic> result = [];
    for (var element in list) {
      result.add(element.toJson());
    }
    return result;
  }

  ///Used to compare two points by hours and minutes.
  @override
  int compareTo(CalendarPoint other) {
    final thisTime = hour! * 60 + min!;
    final otherTime = other.hour! * 60 + other.min!;

    if (thisTime < otherTime) {
      return -1;
    } else if (thisTime > otherTime) {
      return 1;
    } else {
      return 0;
    }
  }
}
