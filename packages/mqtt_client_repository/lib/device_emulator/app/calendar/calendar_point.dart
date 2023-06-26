import 'package:mqtt_client_repository/device_emulator/app/calendar/json_constants.dart';

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

  CalendarPoint.fromJson(Map<String, dynamic> json)
      : day = json[CalendarKey.day],
        hour = json[CalendarKey.hour],
        min = json[CalendarKey.min],
        value = json[CalendarKey.value],
        power = json[CalendarKey.power];

  static CalendarPoint? fromNullableJson(Map<String, dynamic>? json) {
    return json != null ? CalendarPoint.fromJson(json) : null;
  }

  static List<CalendarPoint>? listFromJson(List<dynamic>? json) {
    if (json == null) return null;
    final List<CalendarPoint> daily = [];
    for (var element in json) {
      daily.add(CalendarPoint.fromJson(element));
    }
    return daily;
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
