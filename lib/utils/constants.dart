import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Constants {
  static const serialNumberKey = "SN";
  static const secureCodeKey = "SC";
  static const minSerialNumberLength = 8;
  static const minSecureCodeLength = 8;
  static const formPadding =
      EdgeInsets.only(left: 32, right: 32, top: 48, bottom: 16);

  static const listPadding =
      EdgeInsets.only(left: 10, right: 10, top: 32, bottom: 16);

  static const TextStyle actualTempStyle =
      TextStyle(fontSize: 110, fontWeight: FontWeight.w300);
  static const TextStyle actualTempUnitStyle =
      TextStyle(fontSize: 50, fontWeight: FontWeight.w300);
  static const TextStyle targetTempStyle = TextStyle(fontSize: 40);
  static const TextStyle targetUnitTempStyle = TextStyle(fontSize: 16);

  static const arrowSizeInListMenu = 17.0;

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

  static const topicCalendar = "calendar/";

  /// Topic to set new value
  static const topicCalendarSet = "${topicCalendar}set";

  /// Topic to update indicators
  static const topicCalendarUpdate = "${topicCalendar}update";

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

  static const keyConfig = "config";
  static const keySettings = "settings";

  static const keySettingsGrid = "grid";
  static const keySettingsGridIsEnabled = "isEnabled";
  static const keySettingsGridMinValue = "gridMinValue";

  static const keySettingsPump = "pump";
  static const keySettingsPumpIsAuto = "isAuto";
  static const keySettingsPumpValue = "value";
  static const keySettingsPumpDif = "tempDif";
  static const keySettingsPumpEnableDelay = "enableDelay";
  static const keySettingsPumpDisableDelay = "disableDelay";

  static const keySettingsHeater = "heater";
  static const keySettingsHeaterIsAuto = "isAuto";
  static const keySettingsHeaterValue = "value";

  static const keySettingsWaterTemp = "waterTemp";
  static const keySettingsWaterTempValue = "maxTemp";

  static const keyCalendar = "calendar";
  static const keyCalendarCurrentMode = "currentMode";
  static const keyCalendarCurrentPoint = "currentPoint";
  static const keyCalendarAdditionalPoint = "additionalPoint";
  static const keyCalendarNextPoint = "nextPoint";
  static const keyCalendarModeOff = "off";
  static const keyCalendarModeAntifreeze = "antifreeze";
  static const keyCalendarModeManual = "manual";
  static const keyCalendarModeDaily = "daily";
  static const keyCalendarModeWeekly = "weekly";
  static const keyCalendarDay = "d";
  static const keyCalendarHour = "h";
  static const keyCalendarMin = "m";
  static const keyCalendarValue = "v";
  static const keyCalendarPower = "p";

  static const minWaterTempDif = 1;
  static const maxWaterTempDif = 20;

  static const minWaterTempValue = 20;
  static const maxWaterTempValue = 90;

  static const minAirTempValue = 5.0;
  static const maxAirTempValue = 40.0;
  static const airTempStep = 0.5;

  static const minGridValue = 160;
  static const maxGridValue = 230;

  static const minPumpPwmValue = 10;
  static const maxPumpPwmValue = 100;

  static const minPumpSwitchedValue = 0;
  static const maxPumpSwitchedValue = 3;

  static const minPumpDelayValue = 5;
  static const maxPumpDelayValue = 60;

  static const minHeaterConfig = 1;
}
