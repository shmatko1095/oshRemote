part of 'pump.dart';

extension _WaterTemp on _PumpState {
  void addWaterTempDifItems(BuildContext context) {
    _settingsList.add(ListTile(
        title: Text(S.of(context)!.temp_in_out_dif),
        subtitle: Text(S.of(context)!.temp_in_out_dif_subtitle),
        trailing: Text("${_val.inOutDif}°C")));

    _settingsList.add(Slider(
      value: _val.inOutDif.toDouble(),
      divisions:
          (Constants.maxWaterTempDif - Constants.minWaterTempDif).round(),
      min: Constants.minWaterTempDif.toDouble(),
      max: Constants.maxWaterTempDif.toDouble(),
      onChanged: _val.isAuto ? _onDifChanged : null,
    ));
  }
}
