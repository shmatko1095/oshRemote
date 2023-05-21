import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:osh_remote/block/thing_cubit/model/settings/water_temp_settings.dart';
import 'package:osh_remote/block/thing_cubit/thing_controller_cubit.dart';
import 'package:osh_remote/utils/constants.dart';

class WaterTemp extends StatefulWidget {
  const WaterTemp({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const WaterTemp());
  }

  static Widget getListTile(BuildContext context) {
    return ListTile(
      title: Text(S.of(context)!.waterTemp),
      leading: const Icon(Icons.thermostat),
      trailing: const Icon(Icons.arrow_forward_ios,
          size: Constants.arrowSizeInListMenu),
      onTap: () => Navigator.of(context).push(route()),
    );
  }

  @override
  State<StatefulWidget> createState() => _WaterTempState();
}

class _WaterTempState extends State<WaterTemp> {
  WaterTempSettings get _val => context
      .read<ThingControllerCubit>()
      .state
      .connectedThing!
      .settings!
      .waterTemp;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text(S.of(context)!.mains),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: SingleChildScrollView(
                padding: Constants.listPadding,
                child: Column(
                  children: <Widget>[
                    ListTile(
                        title: Text(S.of(context)!.maxWaterTemp),
                        trailing: Text("${_val.maxTemp}°C")),
                    Slider(
                      value: _val.maxTemp.toDouble(),
                      max: Constants.maxWaterTempValue.toDouble(),
                      min: Constants.minWaterTempValue.toDouble(),
                      onChanged: (value) =>
                          setState(() => _val.maxTemp = value.round()),
                    )
                  ],
                ))));
  }
}
