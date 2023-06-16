import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:osh_remote/block/thing_cubit/thing_controller_cubit.dart';
import 'package:osh_remote/block/thing_cubit/thing_controller_state.dart';
import 'package:osh_remote/pages/charts/grid_chart.dart';
import 'package:osh_remote/utils/constants.dart';

class Charts extends StatefulWidget {
  const Charts({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const Charts());
  }

  @override
  State<Charts> createState() => _ChartsState();
}

class _ChartsState extends State<Charts> {
  ThingControllerCubit get _cubit => context.read<ThingControllerCubit>();

  void _onBackPress() {
    Navigator.of(context).pop();
  }

  Widget _buildChartsColumn(BuildContext context, ThingControllerState state) {
    List<Widget> content = [];
    if (state.charts != null) {
      if (state.charts!.gridData != null) content.add(GridChart());
      if (state.charts!.heaterData != null) content.add(GridChart());
      if (state.charts!.heaterData != null) content.add(GridChart());
      if (state.charts!.heaterData != null) content.add(GridChart());
    }
    return Column(children: content);
  }

  Widget _timeSelectorButton(int time) {
    return ElevatedButton(
      onPressed: () => setState(() => _cubit.state.charts?.incTimeOption()),
      style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          )),
          backgroundColor:
              MaterialStateColor.resolveWith((states) => Colors.blue)),
      child: Text("$time ${S.of(context)!.hour}"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: BlocBuilder<ThingControllerCubit, ThingControllerState>(
            buildWhen: (p, c) => p.charts != c.charts,
            builder: (context, state) => Scaffold(
                  appBar: AppBar(
                    title: Text(S.of(context)!.charts),
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: _onBackPress,
                    ),
                  ),
                  body: SingleChildScrollView(
                      padding: Constants.listPadding,
                      child: _buildChartsColumn(context, state)),
                  floatingActionButton: state.charts != null
                      ? _timeSelectorButton(state.charts!.timeOption)
                      : null,
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.miniEndDocked,
                )));
  }
}
