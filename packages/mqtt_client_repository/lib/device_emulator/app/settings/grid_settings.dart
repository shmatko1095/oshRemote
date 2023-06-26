class GridKey {
  static const isEnabled = "isEnabled";
  static const minValue = "gridMinValue";
}

class GridSetting {
  bool isEnabled;
  int gridMinValue;

  GridSetting({required this.isEnabled, required this.gridMinValue});

  GridSetting.fromJson(Map<String, dynamic> json)
      : isEnabled = json[GridKey.isEnabled],
        gridMinValue = json[GridKey.minValue];

  Map<String, dynamic> toJson() => {
        GridKey.isEnabled: isEnabled,
        GridKey.minValue: gridMinValue,
      };
}
