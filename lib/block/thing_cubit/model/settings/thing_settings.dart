import 'package:osh_remote/block/thing_cubit/model/settings/grid_settings.dart';
import 'package:osh_remote/block/thing_cubit/model/settings/heater_setting.dart';
import 'package:osh_remote/block/thing_cubit/model/settings/pump_settings.dart';
import 'package:osh_remote/block/thing_cubit/model/settings/water_temp_settings.dart';

class SettingsTopic {
  static const _settings = "settings";
  static const set = "$_settings/set";
  static const update = "$_settings/update";
}

class SettingsKey {
  static const settings = "settings";
  static const grid = "grid";
  static const pump = "pump";
  static const heater = "heater";
  static const waterTemp = "waterTemp";
}

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

  static ThingSettings? fromNullableJson(Map<String, dynamic>? json) {
    return json != null ? ThingSettings.fromJson(json) : null;
  }

  ThingSettings.fromJson(Map<String, dynamic> json)
      : grid = GridSetting.fromJson(json[SettingsKey.grid]),
        pump = PumpSettings.fromJson(json[SettingsKey.pump]),
        heater = HeaterSetting.fromJson(json[SettingsKey.heater]),
        waterTemp = WaterTempSettings.fromJson(json[SettingsKey.waterTemp]);

  Map<String, dynamic> toJson() => {
        SettingsKey.grid: grid.toJson(),
        SettingsKey.pump: pump.toJson(),
        SettingsKey.heater: heater.toJson(),
        SettingsKey.waterTemp: waterTemp.toJson(),
      };
}
