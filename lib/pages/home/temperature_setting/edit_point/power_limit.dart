part of 'edit_point.dart';

extension PowerLimit on EditPointScreenState {
  Widget _powerLimitTile() {
    return ListTile(
        title: Text(S.of(context)!.power),
        trailing: Text("${widget.point.power}/${_config.heaterConfig}"));
  }

  Widget _powerLimitSlider() {
    return Slider(
      value: widget.point.power!.toDouble(),
      max: _config.heaterConfig.toDouble(),
      label: "${widget.point.power}/${_config.heaterConfig}",
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
