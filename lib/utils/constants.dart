import 'package:flutter/cupertino.dart';

class Constants {
  static const serialNumberKey = "SN";
  static const secureCodeKey = "SC";
  static const minSerialNumberLength = 8;
  static const minSecureCodeLength = 8;
  static const formPadding =
      EdgeInsets.only(left: 32, right: 32, top: 48, bottom: 16);

  static const topicCommand = "command/";

  /// Topic to connect or disconnect thing
  static const topicConnect = "${topicCommand}connect";

  static const topicData = "data/";

  /// Topic to set new value
  static const topicDataSet = "${topicData}set";

  /// Topic to update indicators
  static const topicDataUpdate = "${topicData}update";

  static const topicSettings = "settings/";

  /// Topic to update settings
  static const topicSettingsUpdate = "${topicSettings}update";

  /// Topic to set settings
  static const topicSettingsSet = "${topicSettings}set";

  ///JSON keys
  static const keyClientId = "clientId";
  static const keyStatus = "status";
  static const keyHeaterStatus = "heaterStatus";
  static const keyHeaterConfig = "heaterConfig";
  static const keyPumpStatus = "pumpStatus";
  static const keyPumpConfig = "pumpConfig";
  static const keyAirTempAct = "airTempAct";
  static const keyAirTempStp = "airTempStp";
  static const keyWaterTempIn = "waterTempIn";
  static const keyWaterTempOut = "waterTempOut";
  static const keyWaterPressure = "waterPressure";
  static const keyPowerUsage = "powerUsage";
  static const keyMode = "mode";
  static const keySwVerMajor = "swVerMajor";
  static const keySwVerMinor = "swVerMinor";
  static const keyHwVerMajor = "hwVerMajor";
  static const keyHwVerMinor = "hwVerMinor";

  static const keySettingsGrid = "grid";
  static const keySettingsGridIsEnabled = "isEnabled";
  static const keySettingsGridMinValue = "gridMinValue";

  static const keySettingsPump = "pump";
  static const keySettingsPumpIsAuto = "isAuto";
  static const keySettingsPumpValue = "value";

  static const keySettingsHeater = "heater";
  static const keySettingsHeaterIsAuto = "isAuto";
  static const keySettingsHeaterIsGridRelated = "isGridRelated";
  static const keySettingsHeaterValue = "value";

  static const keySettingsWaterTemp = "waterTemp";
  static const keySettingsWaterTempValue = "maxTemp";

  static const minWaterTempValue = 20;
  static const maxWaterTempValue = 90;
}
