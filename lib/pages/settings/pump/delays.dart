part of 'pump.dart';

extension _Delay on _PumpState {
  void addDisableDelayItems(BuildContext context) {
    _settingsList.add(ListTile(
        title: Text(S.of(context)!.pump_disable_delay),
        trailing: Text("${_val.disableDelay} ${S.of(context)!.seconds}")));

    _settingsList.add(Slider(
      value: _val.disableDelay.toDouble(),
      min: Constants.minPumpDelayValue.toDouble(),
      max: Constants.maxPumpDelayValue.toDouble(),
      onChanged: _onDisableDelayChanged,
    ));
  }

  void addEnableDelayItems(BuildContext context) {
    _settingsList.add(ListTile(
        title: Text(S.of(context)!.pump_enable_delay),
        trailing: Text("${_val.enableDelay} ${S.of(context)!.seconds}")));

    _settingsList.add(Slider(
      value: _val.enableDelay.toDouble(),
      min: Constants.minPumpDelayValue.toDouble(),
      max: Constants.maxPumpDelayValue.toDouble(),
      onChanged: _onEnableDelayChanged,
    ));
  }
}
