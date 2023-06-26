import 'package:mqtt_client_repository/device_emulator/app/settings/grid_settings.dart';
import 'package:mqtt_client_repository/device_emulator/app/settings/heater_setting.dart';
import 'package:mqtt_client_repository/device_emulator/app/settings/pump_settings.dart';
import 'package:mqtt_client_repository/device_emulator/app/settings/water_temp_settings.dart';
import 'package:mqtt_client_repository/device_emulator/constants.dart';
import 'package:mqtt_client_repository/device_emulator/mqtt/I_mqtt_client.dart';
import 'package:mqtt_client_repository/device_emulator/mqtt/i_mqtt_service.dart';

class SettingsTopic {
  static const set = "${PublicMqttTopics.settings}/set";
  static const update = "${PublicMqttTopics.settings}/update";
}

class SettingsKey {
  static const grid = "grid";
  static const pump = "pump";
  static const heater = "heater";
  static const waterTemp = "waterTemp";
}

class Settings implements IMqttClient {
  late GridSetting grid;
  late PumpSettings pump;
  late HeaterSetting heater;
  late WaterTempSettings waterTemp;
  final IMqttService _mqttService;

  Settings({required IMqttService mqttService}) : _mqttService = mqttService {
    grid = GridSetting(isEnabled: true, gridMinValue: 210);
    heater = HeaterSetting(isAuto: true, value: 5);
    waterTemp = WaterTempSettings(maxTemp: 45);
    pump = PumpSettings(
        isAuto: false,
        value: 50,
        inOutDif: 10,
        enableDelay: 50,
        disableDelay: 50);
  }

  void fromJson(Map<String, dynamic> json) {
    grid = GridSetting.fromJson(json[SettingsKey.grid]);
    pump = PumpSettings.fromJson(json[SettingsKey.pump]);
    heater = HeaterSetting.fromJson(json[SettingsKey.heater]);
    waterTemp = WaterTempSettings.fromJson(json[SettingsKey.waterTemp]);
  }

  Map<String, dynamic> _toJson() => {
        SettingsKey.grid: grid.toJson(),
        SettingsKey.pump: pump.toJson(),
        SettingsKey.heater: heater.toJson(),
        SettingsKey.waterTemp: waterTemp.toJson(),
      };

  void init() {
    _mqttService.subscribe(PublicMqttTopics.connect, this);
    _mqttService.subscribe(PublicMqttTopics.settings, this);
  }

  @override
  Map<String, Map<String, dynamic>>? handle(String topic, String payload) {
    if (topic.endsWith(PublicMqttTopics.connect)) {
      return _handleConnect();
    }
    return null;
  }

  Map<String, Map<String, dynamic>> _handleConnect() {
    Map<String, Map<String, dynamic>> res = {};
    res[PublicMqttTopics.settings] = _toJson();
    return res;
  }
}
