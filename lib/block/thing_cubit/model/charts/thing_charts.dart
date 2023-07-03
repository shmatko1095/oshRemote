import 'package:osh_remote/block/thing_cubit/model/charts/chart_data.dart';

class ChartTopic {
  static const charts = "charts";
  static const update = "$charts/update";
}

enum ThingChartsKey {
  temp,
  heater,
  inTemp,
  outTemp,
  pump,
  pressure,
  grid,
  powerUsage,
}

class ThingCharts {
  final Map<String, ChartData> charts = {};

  static ThingCharts? fromNullableJson(Map<String, dynamic>? json) {
    return json != null ? ThingCharts.fromJson(json) : null;
  }

  ThingCharts.fromJson(Map<String, dynamic> json) {
    for (var element in ThingChartsKey.values) {
      var chart = ChartData.fromNullableJsonArray(json[element.name]);
      if (chart != null) charts[element.name] = chart;
    }
  }
}
