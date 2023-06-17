import 'package:osh_remote/block/thing_cubit/model/charts/chart_data.dart';

class ChartTopic {
  static const _charts = "charts";
  static const update = "$_charts/update";
}

class ThingChartsKey {
  static const charts = "charts";
  static const heater = "heater";
  static const grid = "grid";
}

class ThingCharts {
  final List<int> timeOptions = [1, 3, 6, 12, 24];

  int _timeOptionIndex = 0;

  int get _nextTimeOptionIndex => (_timeOptionIndex + 1) % timeOptions.length;

  int get timeOption => timeOptions[_timeOptionIndex];

  void incTimeOption() => _timeOptionIndex = _nextTimeOptionIndex;

  final ChartData? _heater;
  final ChartData? _mains;
  final ChartData? _temp;
  final ChartData? _pressure;
  final ChartData? _airTemp;
  final ChartData? _inTemp;
  final ChartData? _outTemp;

  ChartData? get heater => _heater?.timeFilteredData(timeOption);

  ChartData? get mains => _mains?.timeFilteredData(timeOption);

  ChartData? get temp => _temp?.timeFilteredData(timeOption);

  ChartData? get pressure => _pressure?.timeFilteredData(timeOption);

  ChartData? get airTemp => _airTemp?.timeFilteredData(timeOption);

  ChartData? get inTemp => _inTemp?.timeFilteredData(timeOption);

  ChartData? get outTemp => _outTemp?.timeFilteredData(timeOption);

  static ThingCharts? fromNullableJson(Map<String, dynamic>? json) {
    return json != null ? ThingCharts.fromJson(json) : null;
  }

  ThingCharts.fromJson(Map<String, dynamic> json)
      : _heater = ChartData.fromNullableJsonArray(json[ThingChartsKey.heater]),
        _mains = ChartData.fromNullableJsonArray(json[ThingChartsKey.grid]),
        _temp = ChartData.fromNullableJsonArray(json[ThingChartsKey.grid]),
        _pressure = ChartData.fromNullableJsonArray(json[ThingChartsKey.grid]),
        _airTemp = ChartData.fromNullableJsonArray(json[ThingChartsKey.grid]),
        _inTemp = ChartData.fromNullableJsonArray(json[ThingChartsKey.grid]),
        _outTemp = ChartData.fromNullableJsonArray(json[ThingChartsKey.grid]);
}
