import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:osh_remote/block/thing_cubit/model/calendar/calendar_point.dart';
import 'package:osh_remote/block/thing_cubit/thing_controller_cubit.dart';
import 'package:osh_remote/utils/constants.dart';

class Manual extends StatefulWidget {
  const Manual({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const Manual());
  }

  @override
  State createState() => _ManualState();
}

class _ManualState extends State<Manual> {
  late FixedExtentScrollController _scrollController;

  CalendarPoint get _point => context
      .read<ThingControllerCubit>()
      .state
      .connectedThing!
      .calendar!
      .manual;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollController =
        FixedExtentScrollController(initialItem: _valueToIndex(_point.value));
  }

  void _onBackPress() {
    Navigator.of(context).pop();
  }

  void _onConfirm() {
    context.read<ThingControllerCubit>().pushManualCalendar();
    Navigator.of(context).pop();
  }

  double _indexToValue(int index) =>
      Constants.minAirTempValue + (index * Constants.airTempStep);

  int _valueToIndex(double value) =>
      ((value - Constants.minAirTempValue) / Constants.airTempStep).round();

  void _onValueSelected(int index) => _point.value = _indexToValue(index);

  Widget _tempScrollSetting() {
    return SizedBox(
      height: 300,
      width: 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: ListWheelScrollView(
              itemExtent: 70,
              overAndUnderCenterOpacity: 0.5,
              controller: _scrollController,
              physics: const FixedExtentScrollPhysics(),
              onSelectedItemChanged: _onValueSelected,
              children: List.generate(
                  _valueToIndex(Constants.maxAirTempValue).round() + 1,
                  (index) => Text(
                      _indexToValue(index).toString().padLeft(2, '0'),
                      style: Constants.actualTempUnitStyle)),
            ),
          ),
          const Flexible(
            child: Text('°C',
                style: TextStyle(
                    fontSize: 50, fontWeight: FontWeight.w300, height: 0.8)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(S.of(context)!.manualMode),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: _onBackPress,
        ),
      ),
      body: SingleChildScrollView(
        padding: Constants.formPadding,
        child: Column(
          children: [
            _tempScrollSetting(),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onConfirm,
                child: Text(S.of(context)!.confirm),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
