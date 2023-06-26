class PumpKey {
  static const isAuto = "isAuto";
  static const value = "value";
  static const inOutDif = "tempDif";
  static const enableDelay = "enableDelay";
  static const disableDelay = "disableDelay";
}

class PumpSettings {
  bool isAuto;

  /// Can be 0-6 if PumpConfig is "switched" and 0-100% if PumpConfig is "pwm"
  int value;
  int inOutDif;
  int enableDelay;
  int disableDelay;

  PumpSettings(
      {required this.isAuto,
      required this.value,
      required this.inOutDif,
      required this.enableDelay,
      required this.disableDelay});

  PumpSettings.fromJson(Map<String, dynamic> json)
      : isAuto = json[PumpKey.isAuto],
        value = json[PumpKey.value],
        inOutDif = json[PumpKey.inOutDif],
        enableDelay = json[PumpKey.enableDelay],
        disableDelay = json[PumpKey.disableDelay];

  Map<String, dynamic> toJson() => {
        PumpKey.isAuto: isAuto,
        PumpKey.value: value,
        PumpKey.inOutDif: inOutDif,
        PumpKey.enableDelay: enableDelay,
        PumpKey.disableDelay: disableDelay,
      };
}
