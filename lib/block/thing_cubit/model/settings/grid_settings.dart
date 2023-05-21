import 'package:osh_remote/utils/constants.dart';

class GridSetting {
  bool isEnabled;
  int gridMinValue;

  GridSetting({required this.isEnabled, required this.gridMinValue});

  GridSetting.fromJson(Map<String, dynamic> json)
      : isEnabled = json[Constants.keySettingsGridIsEnabled],
        gridMinValue = json[Constants.keySettingsGridMinValue];

  Map<String, dynamic> toJson() => {
        Constants.keySettingsGridIsEnabled: isEnabled,
        Constants.keySettingsGridMinValue: gridMinValue,
      };
}
