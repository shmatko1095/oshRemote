import 'package:osh_remote/utils/constants.dart';

class WaterTempSettings {
  int maxTemp;

  WaterTempSettings({required this.maxTemp});

  WaterTempSettings.fromJson(Map<String, dynamic> json)
      : maxTemp = json[Constants.keySettingsWaterTempValue];

  Map<String, dynamic> toJson() => {
        Constants.keySettingsWaterTempValue: maxTemp,
      };
}
