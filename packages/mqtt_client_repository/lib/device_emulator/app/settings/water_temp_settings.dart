class WaterTempKey {
  static const maxTemp = "maxTemp";
}

class WaterTempSettings {
  int maxTemp;

  WaterTempSettings({required this.maxTemp});

  WaterTempSettings.fromJson(Map<String, dynamic> json)
      : maxTemp = json[WaterTempKey.maxTemp];

  Map<String, dynamic> toJson() => {
        WaterTempKey.maxTemp: maxTemp,
      };
}
