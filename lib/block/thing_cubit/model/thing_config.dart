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
}
