class ChartData {
  static const String splitter = " ";
  final Map<int, int> _data = {};

  Map<int, int> get data => Map.from(_data);

  int get maxV => data.values.reduce((a, b) => a > b ? a : b);

  int get minV => data.values.reduce((a, b) => a < b ? a : b);

  int get maxT => data.keys.reduce((a, b) => a > b ? a : b);

  int get minT => data.keys.reduce((a, b) => a < b ? a : b);

  int _getTime(String data) => int.parse(data.split(splitter).first);

  int _getValue(String data) => int.parse(data.split(splitter).last);

  ChartData(Map<int, int> data) {
    _data.addAll(data);
  }

  ChartData timeFilteredData(int timeOption) {
    int threshold = maxT - (Duration.secondsPerHour * timeOption);
    Map<int, int> filteredMap = {};
    data.forEach((key, value) {
      if (key >= threshold) {
        filteredMap[key] = value;
      }
    });
    return ChartData(filteredMap);
  }

  static ChartData? fromNullableJsonArray(List<dynamic>? json) {
    return json != null ? ChartData.fromJsonArray(json) : null;
  }

  ChartData.fromJsonArray(List<dynamic> json) {
    for (var element in json) {
      _data[_getTime(element)] = _getValue(element);
    }
  }
}
