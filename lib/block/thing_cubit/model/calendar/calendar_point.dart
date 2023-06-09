import 'package:osh_remote/block/thing_cubit/model/calendar/thing_calendar.dart';

enum Day { off, antifreeze, manual, daily, weekly }

class CalendarPoint implements Comparable<CalendarPoint> {
  int? day;
  int? min;
  int? hour;
  double value;
  int? power;

  int get timeId {
    int res = 0;
    List<bool> dayBitList =
        List.generate(7, (i) => day != null ? ((day! >> i) & 1) > 0 : false);

    for (var index = 0; index < dayBitList.length; index++) {
      res += dayBitList[index] ? index * 24 * 60 : 0;
    }
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

  static CalendarPoint? fromNullableJson(Map<String, dynamic>? json) {
    return json != null ? CalendarPoint.fromJson(json) : null;
  }

  Map<String, dynamic> toJson() => {
        CalendarKey.day: day,
        CalendarKey.hour: hour,
        CalendarKey.min: min,
        CalendarKey.value: value,
        CalendarKey.power: power,
      };

  static Map<int, CalendarPoint>? mapFromJson(List<dynamic>? json) {
    if (json == null) return null;
    Map<int, CalendarPoint> map = {};
    for (var element in json) {
      CalendarPoint point = CalendarPoint.fromJson(element);
      map[point.timeId] = point;
    }
    return map;
  }

  static List<dynamic> mapToJson(Map<int, CalendarPoint> map) {
    List<CalendarPoint> list = map.values.toList();
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
