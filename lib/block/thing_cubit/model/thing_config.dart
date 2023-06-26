class ConfigTopic {
  static const _config = "config";
  static const update = "$_config/update";
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

enum PumpConfig {
  constant,
  switched,
  pwm,
}

class ThingConfig {
  final PumpConfig pumpConfig;
  final int heaterConfig;
  final int swVerMinor;
  final int swVerMajor;
  final int hwVerMinor;
  final int hwVerMajor;

  ThingConfig(
      {required this.pumpConfig,
      required this.heaterConfig,
      required this.swVerMinor,
      required this.swVerMajor,
      required this.hwVerMinor,
      required this.hwVerMajor});

  const ThingConfig.pure()
      : pumpConfig = PumpConfig.constant,
        heaterConfig = -1,
        hwVerMajor = -1,
        hwVerMinor = -1,
        swVerMajor = -1,
        swVerMinor = -1;

  static ThingConfig? fromNullableJson(Map<String, dynamic>? json) {
    return json != null ? ThingConfig.fromJson(json) : null;
  }

  ThingConfig.fromJson(Map<String, dynamic> json)
      : pumpConfig = PumpConfig.values[json[ConfigKey.pumpConfig]],
        heaterConfig = json[ConfigKey.heaterConfig],
        hwVerMajor = json[ConfigKey.hwVerMajor],
        hwVerMinor = json[ConfigKey.hwVerMinor],
        swVerMajor = json[ConfigKey.swVerMajor],
        swVerMinor = json[ConfigKey.swVerMinor];

  Map<String, dynamic> toJson() => {
        ConfigKey.pumpConfig: pumpConfig,
        ConfigKey.heaterConfig: heaterConfig,
        ConfigKey.hwVerMajor: hwVerMajor,
        ConfigKey.hwVerMinor: hwVerMinor,
        ConfigKey.swVerMajor: swVerMajor,
        ConfigKey.swVerMinor: swVerMinor,
      };
}
