class HeaterKey {
  static const isAuto = "isAuto";
  static const value = "value";
}

class HeaterSetting {
  /// Value "true" means enabled modulation.
  bool isAuto;

  /// Can be from 0 to ThingConfig.heaterConfig
  int value;

  HeaterSetting({required this.isAuto, required this.value});

  HeaterSetting.fromJson(Map<String, dynamic> json)
      : isAuto = json[HeaterKey.isAuto],
        value = json[HeaterKey.value];

  Map<String, dynamic> toJson() => {
        HeaterKey.isAuto: isAuto,
        HeaterKey.value: value,
      };
}
