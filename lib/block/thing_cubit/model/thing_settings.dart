import 'package:osh_remote/block/thing_cubit/model/settings/grid_settings.dart';
import 'package:osh_remote/block/thing_cubit/model/settings/heater_setting.dart';
import 'package:osh_remote/block/thing_cubit/model/settings/pump_settings.dart';
import 'package:osh_remote/block/thing_cubit/model/settings/water_temp_settings.dart';

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

  ThingSettings.pure()
      : grid = GridSetting(isEnabled: false, gridMinValue: -1),
        pump = PumpSettings(isAuto: false, value: -1),
        heater = HeaterSetting(isAuto: false, isGridRelated: false, value: -1),
        waterTemp = WaterTempSettings(maxTemp: -1);
}
