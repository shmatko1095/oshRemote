import 'package:osh_remote/utils/constants.dart';

class HeaterSetting {
  /// Value "true" means enabled modulation.
  bool isAuto;

  /// Can be from 0 to ThingConfig.heaterConfig
  int value;

  HeaterSetting({required this.isAuto, required this.value});

  HeaterSetting.fromJson(Map<String, dynamic> json)
      : isAuto = json[Constants.keySettingsHeaterIsAuto],
        value = json[Constants.keySettingsHeaterValue];

  Map<String, dynamic> toJson() => {
        Constants.keySettingsHeaterIsAuto: isAuto,
        Constants.keySettingsHeaterValue: value,
      };
}
