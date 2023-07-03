class PublicMqttTopics {
  static const info = "info";
  static const config = "config";
  static const charts = "charts";
  static const calendar = "calendar";
  static const settings = "settings";
  static const connect = "command/connect";
}

class ConfigKey {
  static const config = "config";
  static const client = "client";
  static const clientId = "id";
  static const status = "status";
  static const heaterConfig = "heaterConfig";
  static const pumpConfig = "pumpConfig";
  static const swVerMajor = "swVerMajor";
  static const swVerMinor = "swVerMinor";
  static const hwVerMajor = "hwVerMajor";
  static const hwVerMinor = "hwVerMinor";
}

class Constants {
  static const topicCommand = "command/";

  /// Topic to connect or disconnect thing
  static const topicConnect = "${topicCommand}connect";

  static const minWaterTempDif = 1;
  static const maxWaterTempDif = 20;

  static const minWaterTempValue = 20;
  static const maxWaterTempValue = 90;

  static const minAirTempValue = 5.0;
  static const maxAirTempValue = 40.0;
  static const airTempStep = 0.5;

  static const minGridValue = 160;
  static const maxGridValue = 230;

  static const minChartGridValue = minGridValue;
  static const maxChartGridValue = 260;

  static const minPumpPwmValue = 10;
  static const maxPumpPwmValue = 100;

  static const minPumpSwitchedValue = 0;
  static const maxPumpSwitchedValue = 3;

  static const minPumpDelayValue = 5;
  static const maxPumpDelayValue = 60;

  static const minHeaterConfig = 1;
}
