part of 'additional_point.dart';

extension PowerLimit on AdditionalPointScreenState {
  Widget _powerLimitTile() {
    return ListTile(
        title: Text(S.of(context)!.power),
        trailing:
            Text("${_calendar.additional!.power}/${_config.heaterConfig}"));
  }

  Widget _powerLimitSlider() {
    return Slider(
      value: _calendar.additional!.power!.toDouble(),
      max: _config.heaterConfig.toDouble(),
      label: "${_calendar.additional!.power}/${_config.heaterConfig}",
      onChanged: _onPowerLimitValueChanged,
      divisions: _config.heaterConfig,
    );
  }

  Widget powerLimitSettings() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[_powerLimitTile(), _powerLimitSlider()]);
  }
}
