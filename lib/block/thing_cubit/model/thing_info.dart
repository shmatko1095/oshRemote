class InfoTopic {
  static const _info = "info";
  static const set = "$_info/set";
  static const update = "$_info/update";
}

class InfoKey {
  static const info = "info";
  static const heaterStatus = "hS";
  static const pumpStatus = "pS";
  static const tempIn = "tI";
  static const tempOut = "tO";
  static const pressure = "pr";
  static const powerUsage = "pU";
  static const airTempAct = "aTA";
}

class ThingInfo {
  int heaterStatus;
  int pumpStatus;
  double tempIn;
  double tempOut;
  double pressure;
  int powerUsage;
  double airTemp;

  ThingInfo(
      {required this.heaterStatus,
      required this.pumpStatus,
      required this.powerUsage,
      required this.pressure,
      required this.tempIn,
      required this.tempOut,
      required this.airTemp});

  static ThingInfo? fromNullableJson(Map<String, dynamic>? json) {
    return json != null ? ThingInfo.fromJson(json) : null;
  }

  ThingInfo.fromJson(Map<String, dynamic> json)
      : heaterStatus = json[InfoKey.heaterStatus],
        pumpStatus = json[InfoKey.pumpStatus],
        powerUsage = json[InfoKey.powerUsage],
        pressure = json[InfoKey.pressure],
        tempIn = json[InfoKey.tempIn],
        tempOut = json[InfoKey.tempOut],
        airTemp = json[InfoKey.airTempAct];

  Map<String, dynamic> toJson() => {
        InfoKey.heaterStatus: heaterStatus,
        InfoKey.pumpStatus: pumpStatus,
        InfoKey.powerUsage: powerUsage,
        InfoKey.pressure: pressure,
        InfoKey.tempIn: tempIn,
        InfoKey.tempOut: tempOut,
        InfoKey.airTempAct: airTemp,
      };
}
