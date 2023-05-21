part of 'pump.dart';

extension _PumpPerformance on _PumpState {
  ///Add BlocBuilder using to update _val.value in real-time
  ///if it was changed on device in AutoMode
  Widget _performanceTrailing() {
    return _config == PumpConfig.pwm
        ? Text("${_val.value}%")
        : Text("${_val.value}/3");
  }

  Widget _performanceSliderSwitched() {
    return Slider(
        value: _val.value.toDouble(),
        min: Constants.minPumpSwitchedValue.toDouble(),
        max: Constants.maxPumpSwitchedValue.toDouble(),
        onChanged: _val.isAuto ? null : _onPerformanceValueChanged,
        divisions:
            Constants.maxPumpSwitchedValue - Constants.minPumpSwitchedValue);
  }

  Widget _performanceSliderPwm() {
    return Slider(
      value: _val.value.toDouble(),
      min: Constants.minPumpPwmValue.toDouble(),
      max: Constants.maxPumpPwmValue.toDouble(),
      onChanged: _val.isAuto ? null : _onPerformanceValueChanged,
    );
  }

  void addPerformanceItems(BuildContext context) {
    _settingsList.add(ListTile(
        title: Text(S.of(context)!.pump_auto),
        subtitle: Text(S.of(context)!.pump_auto_subtitle),
        trailing: Switch(
            value: _val.isAuto,
            onChanged: _onPerformanceAutoChanged,
            activeColor: Colors.blue)));

    _settingsList.add(ListTile(
        title: Text(S.of(context)!.pump_performance),
        trailing: _performanceTrailing()));

    _settingsList.add(_config == PumpConfig.pwm
        ? _performanceSliderPwm()
        : _performanceSliderSwitched());
  }
}
