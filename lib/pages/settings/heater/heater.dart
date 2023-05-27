import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:osh_remote/block/thing_cubit/model/settings/heater_setting.dart';
import 'package:osh_remote/block/thing_cubit/thing_controller_cubit.dart';
import 'package:osh_remote/utils/constants.dart';

class Heater extends StatefulWidget {
  const Heater({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const Heater());
  }

  static Widget getListTile(BuildContext context) {
    return ListTile(
      title: Text(S.of(context)!.heater),
      leading: const Icon(Icons.local_fire_department),
      trailing: const Icon(Icons.arrow_forward_ios,
          size: Constants.arrowSizeInListMenu),
      onTap: () => Navigator.of(context).push(route()),
    );
  }

  @override
  State<StatefulWidget> createState() => _HeaterState();
}

class _HeaterState extends State<Heater> {
  HeaterSetting get _val =>
      context.read<ThingControllerCubit>().state.settings!.heater;

  int get _config =>
      context.read<ThingControllerCubit>().state.config!.heaterConfig;

  void _onIsAutoChanged(bool value) => setState(() => _val.isAuto = value);

  void _onValueChanged(double value) {
    int val = value.round();
    if (val >= Constants.minHeaterConfig.toDouble()) {
      setState(() => _val.value = value.round());
    }
  }

  Widget _getTrailing() {
    return _val.isAuto
        ? Text(S.of(context)!.auto)
        : Text("${_val.value}/$_config");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text(S.of(context)!.heater),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: SingleChildScrollView(
                padding: Constants.listPadding,
                child: Column(children: <Widget>[
                  ListTile(
                      title: Text(S.of(context)!.heater_auto),
                      subtitle: Text(S.of(context)!.heater_auto_subtitle),
                      trailing: Switch(
                          value: _val.isAuto,
                          onChanged: _onIsAutoChanged,
                          activeColor: Colors.blue)),
                  ListTile(
                      title: Text(S.of(context)!.heater_mode_value),
                      subtitle: Text(S.of(context)!.heater_mode_value_subtitle),
                      trailing: _getTrailing()),
                  Slider(
                    value: _val.value.toDouble(),
                    min: 0,
                    max: _config.toDouble(),
                    onChanged: _val.isAuto ? null : _onValueChanged,
                    divisions: _config,
                  )
                ]))));
  }
}
