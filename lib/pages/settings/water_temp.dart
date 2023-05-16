import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:osh_remote/block/thing_cubit/model/settings/water_temp_settings.dart';
import 'package:osh_remote/block/thing_cubit/thing_controller_cubit.dart';
import 'package:osh_remote/utils/constants.dart';

class WaterTemp extends StatefulWidget {
  const WaterTemp({super.key});

  @override
  State<StatefulWidget> createState() => _WaterTempState();
}

class _WaterTempState extends State<WaterTemp> {
  int _val = Constants.minWaterTempValue;

  @override
  void initState() {
    super.initState();
    _val = context
        .read<ThingControllerCubit>()
        .state
        .connectedThing!
        .settings
        .waterTemp
        .maxTemp;
  }

  void _onChanged(double value) {
    context
        .read<ThingControllerCubit>()
        .state
        .connectedThing
        ?.settings
        .waterTemp = WaterTempSettings(maxTemp: value.round());
    setState(() => _val = value.round());
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(S.of(context)!.maxWaterTemp),
      trailing: Text("$_val°C"),
      children: <Widget>[
        Slider(
          value: _val.toDouble(),
          max: Constants.maxWaterTempValue.toDouble(),
          min: Constants.minWaterTempValue.toDouble(),
          label: _val.toString(),
          onChanged: _onChanged,
        )
      ],
    );
  }
}
