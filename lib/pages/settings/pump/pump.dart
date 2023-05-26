import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:osh_remote/block/thing_cubit/model/settings/pump_settings.dart';
import 'package:osh_remote/block/thing_cubit/model/thing_config.dart';
import 'package:osh_remote/block/thing_cubit/thing_controller_cubit.dart';
import 'package:osh_remote/utils/constants.dart';

part 'delays.dart';
part 'performance.dart';
part 'water_temp.dart';

class Pump extends StatefulWidget {
  const Pump({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const Pump());
  }

  static Widget getListTile(BuildContext context) {
    return ListTile(
      title: Text(S.of(context)!.pump),
      leading: const Icon(Icons.loop),
      trailing: const Icon(Icons.arrow_forward_ios,
          size: Constants.arrowSizeInListMenu),
      onTap: () => Navigator.of(context).push(route()),
    );
  }

  @override
  State<StatefulWidget> createState() => _PumpState();
}

class _PumpState extends State<Pump> {
  final List<Widget> _settingsList = [];

  PumpSettings get _val =>
      context.read<ThingControllerCubit>().state.settings!.pump;

  PumpConfig get _config =>
      context.read<ThingControllerCubit>().state.config!.pumpConfig;

  void _buildSettingsList() {
    _settingsList.clear();

    if (_config != PumpConfig.constant) {
      addPerformanceItems(context);
      addWaterTempDifItems(context);
    }
    addDisableDelayItems(context);
    addEnableDelayItems(context);
  }

  void _onPerformanceValueChanged(double value) =>
      setState(() => _val.value = value.round());

  void _onPerformanceAutoChanged(bool value) =>
      setState(() => _val.isAuto = value);

  void _onDifChanged(double value) =>
      setState(() => _val.inOutDif = value.round());

  void _onDisableDelayChanged(double value) =>
      setState(() => _val.disableDelay = value.round());

  void _onEnableDelayChanged(double value) =>
      setState(() => _val.enableDelay = value.round());

  @override
  Widget build(BuildContext context) {
    _buildSettingsList();

    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text(S.of(context)!.pump),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: SingleChildScrollView(
                padding: Constants.listPadding,
                child: Column(children: _settingsList))));
  }
}
