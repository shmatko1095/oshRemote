import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:osh_remote/block/thing_cubit/thing_controller_cubit.dart';
import 'package:osh_remote/pages/settings/grid/grid.dart';
import 'package:osh_remote/pages/settings/heater/heater.dart';
import 'package:osh_remote/pages/settings/pump/pump.dart';
import 'package:osh_remote/pages/settings/water_temp/water_temp.dart';
import 'package:osh_remote/utils/constants.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const Settings());
  }

  @override
  State createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final List<Widget> _settingsList = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _buildSettingsList();
  }

  void _onBackPress() {
    context.read<ThingControllerCubit>().pushSettings();
    Navigator.of(context).pop();
  }

  void _buildSettingsList() {
    _settingsList.add(Pump.getListTile(context));
    _settingsList.add(Grid.getListTile(context));
    _settingsList.add(Heater.getListTile(context));
    _settingsList.add(WaterTemp.getListTile(context));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text(S.of(context)!.settings),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: _onBackPress,
            ),
          ),
          body: SingleChildScrollView(
            padding: Constants.listPadding,
            child: Column(
              children: _settingsList,
            ),
          )),
    );
  }
}
