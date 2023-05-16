import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:osh_remote/block/thing_cubit/thing_controller_cubit.dart';
import 'package:osh_remote/pages/settings/water_temp.dart';
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
  @override
  void initState() {
    super.initState();
  }

  void _onBackPress() {
    context.read<ThingControllerCubit>().pushSettings();
    Navigator.of(context).pop();
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
            padding: Constants.formPadding,
            child: Column(
              children: <Widget>[
                const WaterTemp(),
                Container(
                  height: 600,
                  color: Colors.green,
                  child: Center(
                    child: Text(
                      'Content',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 200,
                  color: Colors.red,
                  child: Center(
                    child: Text(
                      'Footer',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
