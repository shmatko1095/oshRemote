class HeaterSetting {
  /// Value "true" means enabled modulation.
  final bool isAuto;

  final bool isGridRelated;

  /// Can be from 0 to ThingConfig.heaterConfig
  final int value;

  HeaterSetting(
      {required this.isAuto, required this.isGridRelated, required this.value});
}
