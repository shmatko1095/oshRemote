class PumpSettings {
  final bool isAuto;

  /// Can be 0-6 if PumpConfig is "switched" and 0-100% if PumpConfig is "pwm"
  final int value;

  PumpSettings({required this.isAuto, required this.value});
}
