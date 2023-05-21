import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:osh_remote/block/thing_cubit/model/settings/grid_settings.dart';
import 'package:osh_remote/block/thing_cubit/thing_controller_cubit.dart';
import 'package:osh_remote/utils/constants.dart';

class Grid extends StatefulWidget {
  const Grid({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const Grid());
  }

  static Widget getListTile(BuildContext context) {
    return ListTile(
      title: Text(S.of(context)!.mains),
      leading: const Icon(Icons.power_settings_new),
      trailing: const Icon(Icons.arrow_forward_ios,
          size: Constants.arrowSizeInListMenu),
      onTap: () => Navigator.of(context).push(route()),
    );
  }

  @override
  State<StatefulWidget> createState() => _GridState();
}

class _GridState extends State<Grid> {
  GridSetting get _val =>
      context.read<ThingControllerCubit>().state.connectedThing!.settings!.grid;

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
                child: Column(children: <Widget>[
                  ExpansionTile(
                    key: Key(_val.isEnabled.toString()),
                    onExpansionChanged: (value) =>
                        setState(() => _val.isEnabled = value),
                    initiallyExpanded: _val.isEnabled,
                    textColor: Theme.of(context).textTheme.titleMedium?.color,
                    title: Text(S.of(context)!.mainsMinIsActiveTitle),
                    subtitle: Text(S.of(context)!.mainsMinIsActiveSubtitle),
                    trailing: Switch(
                        value: _val.isEnabled,
                        onChanged: (val) =>
                            setState(() => _val.isEnabled = val),
                        activeColor: Colors.blue),
                    children: <Widget>[
                      ListTile(
                          title: Text(S.of(context)!.mainsMinValueTitle),
                          trailing: Text("${_val.gridMinValue}V")),
                      Slider(
                          value: _val.gridMinValue.toDouble(),
                          max: Constants.maxGridValue.toDouble(),
                          min: Constants.minGridValue.toDouble(),
                          label: _val.gridMinValue.toString(),
                          onChanged: _val.isEnabled
                              ? (val) => setState(
                                  () => _val.gridMinValue = val.round())
                              : null)
                    ],
                  )
                ]))));
  }
}
