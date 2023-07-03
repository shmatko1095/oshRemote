import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:osh_remote/block/thing_cubit/model/charts/chart_data.dart';
import 'package:osh_remote/block/thing_cubit/model/charts/thing_charts.dart';
import 'package:osh_remote/block/thing_cubit/thing_controller_cubit.dart';
import 'package:osh_remote/block/thing_cubit/thing_controller_state.dart';
import 'package:osh_remote/pages/charts/chart.dart';
import 'package:osh_remote/pages/charts/chart_styles.dart';
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
  static const List<int> _timeOptions = [1, 3, 6, 12, 24];

  int _timeOptionIndex = 0;

  int get _nextTimeOptionIndex => (_timeOptionIndex + 1) % _timeOptions.length;

  int get _timeOption => _timeOptions[_timeOptionIndex];

  ThingControllerCubit get _cubit => context.read<ThingControllerCubit>();

  Map<String, ChartData> get _charts => _cubit.state.charts!.charts;

  void _onBackPress() => Navigator.of(context).pop();

  Widget _buildChartsColumn(BuildContext context, ThingControllerState st) {
    List<Widget> content = [];
    if (st.charts != null) {
      for (var k in ThingChartsKey.values) {
        if (_charts[k.name] != null) {
          ChartData data = _charts[k.name]!.timeFilteredData(_timeOption);
          content.add(Chart(
            name: ChartStyles.getNameByKey(k, context),
            minY: ChartStyles.getMinByKey(k, data.minV.toDouble()),
            maxY: ChartStyles.getMaxByKey(k, st.config, data.maxV.toDouble()),
            units: ChartStyles.getUnitsByKey(k, st.config),
            isCurved: ChartStyles.getCurvedByKey(k),
            gradient: ChartStyles.getGradientByKey(k),
            data: data,
          ));
        }
      }
    }
    return Column(children: content);
  }

  Widget _timeSelectorButton() {
    return ElevatedButton(
      onPressed: () => setState(() => _timeOptionIndex = _nextTimeOptionIndex),
      style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          )),
          backgroundColor: MaterialStateColor.resolveWith((_) => Colors.blue)),
      child: Text("$_timeOption ${S.of(context)!.hour}"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: BlocBuilder<ThingControllerCubit, ThingControllerState>(
            buildWhen: (p, c) =>
                const MapEquality().equals(p.charts?.charts, c.charts?.charts),
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
                  floatingActionButton:
                      state.charts != null ? _timeSelectorButton() : null,
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.miniEndDocked,
                )));
  }
}
