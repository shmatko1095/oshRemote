import 'package:osh_remote/utils/constants.dart';

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

  ThingConfig.fromJson(Map<String, dynamic> json)
      : pumpConfig = PumpConfig.values[json[Constants.keyPumpConfig]],
        heaterConfig = json[Constants.keyHeaterConfig],
        hwVerMajor = json[Constants.keyHwVerMajor],
        hwVerMinor = json[Constants.keyHwVerMinor],
        swVerMajor = json[Constants.keySwVerMajor],
        swVerMinor = json[Constants.keySwVerMinor];

  Map<String, dynamic> toJson() => {
        Constants.keyPumpConfig: pumpConfig,
        Constants.keyHeaterConfig: heaterConfig,
        Constants.keyHwVerMajor: hwVerMajor,
        Constants.keyHwVerMinor: hwVerMinor,
        Constants.keySwVerMajor: swVerMajor,
        Constants.keySwVerMinor: swVerMinor,
      };
}
