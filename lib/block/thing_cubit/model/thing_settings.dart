import 'package:osh_remote/block/thing_cubit/model/settings/grid_settings.dart';
import 'package:osh_remote/block/thing_cubit/model/settings/heater_setting.dart';
import 'package:osh_remote/block/thing_cubit/model/settings/pump_settings.dart';
import 'package:osh_remote/block/thing_cubit/model/settings/water_temp_settings.dart';
import 'package:osh_remote/utils/constants.dart';

class ThingSettings {
  GridSetting grid;
  PumpSettings pump;
  HeaterSetting heater;
  WaterTempSettings waterTemp;

  ThingSettings(
      {required this.grid,
      required this.pump,
      required this.heater,
      required this.waterTemp});

  ThingSettings.fromJson(Map<String, dynamic> json)
      : grid = GridSetting.fromJson(json[Constants.keySettingsGrid]),
        pump = PumpSettings.fromJson(json[Constants.keySettingsPump]),
        heater = HeaterSetting.fromJson(json[Constants.keySettingsHeater]),
        waterTemp =
            WaterTempSettings.fromJson(json[Constants.keySettingsWaterTemp]);

  Map<String, dynamic> toJson() => {
        Constants.keySettingsGrid: grid.toJson(),
        Constants.keySettingsPump: pump.toJson(),
        Constants.keySettingsHeater: heater.toJson(),
        Constants.keySettingsWaterTemp: waterTemp.toJson(),
      };
}
