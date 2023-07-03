class ChartData {
  static const String splitter = " ";
  final Map<int, dynamic> _data = {};

  Map<int, dynamic> get data => Map.from(_data);

  dynamic get maxV => data.values.reduce((a, b) => a > b ? a : b);

  dynamic get minV => data.values.reduce((a, b) => a < b ? a : b);

  int get maxT => data.keys.reduce((a, b) => a > b ? a : b);

  int get minT => data.keys.reduce((a, b) => a < b ? a : b);

  ChartData(Map<int, dynamic> data) {
    _data.addAll(data);
  }

  ChartData timeFilteredData(int timeOption) {
    int threshold = maxT - (Duration.secondsPerHour * timeOption);
    Map<int, dynamic> filteredMap = {};
    data.forEach((key, value) {
      if (key >= threshold) {
        filteredMap[key] = value;
      }
    });
    return ChartData(filteredMap);
  }

  static ChartData? fromNullableJsonArray(Map<String, dynamic>? json) {
    return json != null ? ChartData.fromJsonArray(json) : null;
  }

  ChartData.fromJsonArray(Map<String, dynamic> json) {
    json.forEach((key, value) => _data[int.parse(key)] = value);
  }
}
