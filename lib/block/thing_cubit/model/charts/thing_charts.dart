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
  final List<int> _timeOptions = [1, 3, 6, 12, 24];

  int get _nextTimeOptionIndex => (_timeOptionIndex + 1) % _timeOptions.length;
  int _timeOptionIndex = 0;

  int get timeOption => _timeOptions[_timeOptionIndex];

  void incTimeOption() {
    _timeOptionIndex = _nextTimeOptionIndex;
    _updateTimeFilteredData();
  }

  final ChartData? _heaterData;
  ChartData? _timeFilteredHeaterData;

  ChartData? get heaterData => _timeFilteredHeaterData;

  final ChartData? _gridData;
  ChartData? _timeFilteredGridData;

  ChartData? get gridData => _timeFilteredGridData;

  static ThingCharts? fromNullableJson(Map<String, dynamic>? json) {
    return json != null ? ThingCharts.fromJson(json) : null;
  }

  ThingCharts.fromJson(Map<String, dynamic> json)
      : _heaterData =
            ChartData.fromNullableJsonArray(json[ThingChartsKey.heater]),
        _gridData = ChartData.fromNullableJsonArray(json[ThingChartsKey.grid]) {
    _updateTimeFilteredData();
  }

  void _updateTimeFilteredData() {
    _timeFilteredGridData =
        ChartData.getTimeFilteredData(_gridData, timeOption);
    _timeFilteredHeaterData =
        ChartData.getTimeFilteredData(_heaterData, timeOption);
  }
}
