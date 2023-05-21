import 'package:osh_remote/utils/constants.dart';

class PumpSettings {
  bool isAuto;

  /// Can be 0-6 if PumpConfig is "switched" and 0-100% if PumpConfig is "pwm"
  int value;
  int inOutDif;
  int enableDelay;
  int disableDelay;

  PumpSettings(
      {required this.isAuto,
      required this.value,
      required this.inOutDif,
      required this.enableDelay,
      required this.disableDelay});

  PumpSettings.fromJson(Map<String, dynamic> json)
      : isAuto = json[Constants.keySettingsPumpIsAuto],
        value = json[Constants.keySettingsPumpValue],
        inOutDif = json[Constants.keySettingsPumpDif],
        enableDelay = json[Constants.keySettingsPumpEnableDelay],
        disableDelay = json[Constants.keySettingsPumpDisableDelay];

  Map<String, dynamic> toJson() => {
        Constants.keySettingsPumpIsAuto: isAuto,
        Constants.keySettingsPumpValue: value,
        Constants.keySettingsPumpDif: inOutDif,
        Constants.keySettingsPumpEnableDelay: enableDelay,
        Constants.keySettingsPumpDisableDelay: disableDelay,
      };
}
