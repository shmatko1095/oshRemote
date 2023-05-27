part of 'additional_point.dart';

extension PowerLimit on AdditionalPointScreenState {
  Widget powerLimitSwitch() {
    return ListTile(
        title: Text(S.of(context)!.powerLimit),
        trailing: Switch(
            value: _calendar.additional!.power != null,
            onChanged: _onPowerLimitActiveChanged,
            activeColor: Colors.blue));
  }

  Widget powerLimitSlider() {
    return Slider(
      value: _calendar.additional!.power!.toDouble(),
      max: _config.heaterConfig.toDouble(),
      label: "${_calendar.additional!.power}/${_config.heaterConfig}",
      onChanged: _onPowerLimitValueChanged,
      divisions: _config.heaterConfig,
    );
  }

  Widget powerLimitSettings() {
    List<Widget> widgets = [];

    widgets.add(powerLimitSwitch());
    if (_calendar.additional!.power != null) {
      widgets.add(powerLimitSlider());
    }

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: widgets);
  }
}
