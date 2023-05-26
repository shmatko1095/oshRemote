import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:osh_remote/block/thing_cubit/model/calendar/calendar_point.dart';
import 'package:osh_remote/block/thing_cubit/model/thing_calendar.dart';
import 'package:osh_remote/block/thing_cubit/model/time_option.dart';
import 'package:osh_remote/block/thing_cubit/thing_controller_cubit.dart';
import 'package:osh_remote/utils/constants.dart';
import 'package:osh_remote/widgets/sized_box_elevated_button.dart';

part 'time_option_button.dart';

class AdditionalPointScreen extends StatefulWidget {
  const AdditionalPointScreen({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(
        builder: (_) => const AdditionalPointScreen());
  }

  @override
  State createState() => _AdditionalPointScreenState();
}

class _AdditionalPointScreenState extends State<AdditionalPointScreen> {
  late FixedExtentScrollController _valController;
  late FixedExtentScrollController _minController;
  late FixedExtentScrollController _hourController;

  static const _scrollHeight = 200.0;
  static const _scrollWidth = 130.0;
  List<Widget> _contentList = [];

  ThingCalendar get _calendar =>
      context.read<ThingControllerCubit>().state.calendar!;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _calendar.additional == null
      ?_calendar.additional = CalendarPoint(value: _calendar.current.value)
      :_calendar.additional!.value = _calendar.current.value;

    _updateControllers();
  }

  void _updateControllers() {
    _valController = FixedExtentScrollController(
        initialItem: _valueToIndex(_calendar.additional!.value));
    _minController = FixedExtentScrollController(
        initialItem: _calendar.additional!.min ?? 0);
    _hourController = FixedExtentScrollController(
        initialItem: _calendar.additional!.hour ?? 0);
  }

  void _buildContent() {
    _updateControllers();

    _contentList.clear();
    _contentList.add(_tempScrollSetting());
    _contentList.add(_timeOptionButtons());
    if (_calendar.additionalTimeOption == TimeOption.setupTime) {
      _contentList.add(_timeScrollSetting());
    }
    _contentList.add(_confirmButton());

    _contentList = _contentList
        .expand((element) => [element, const SizedBox(height: 36)])
        .toList();
  }

  _onTimeOptionPressed(TimeOption val) {
    setState(() {
      _calendar.additionalTimeOption = val;
    });
  }

  _onBackPress() {
    Navigator.of(context).pop();
  }

  _onConfirm() {
    context.read<ThingControllerCubit>().setAdditionalPoint();
    Navigator.of(context).pop();
  }

  Widget _confirmButton() {
    return SizedBoxElevatedButton(
        text: Text(S.of(context)!.confirm), onPressed: () => _onConfirm);
  }

  Widget _timeOptionButtons() {
    List<Widget> buttons = [];
    for (var element in TimeOption.values) {
      buttons.add(Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: ClipOval(
            child: Material(
                color: Colors.blue.withOpacity(
                    _calendar.additionalTimeOption == element ? 1 : 0.2),
                child: InkWell(
                  onTap: () => _onTimeOptionPressed(element),
                  child: SizedBox(
                      width: 56, height: 56, child: element.toIcon(context)),
                )),
          )));
    }
    buttons = buttons
        .expand((element) => (buttons.indexOf(element) != buttons.length - 1)
            ? [element, const Spacer()]
            : [element])
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_calendar.additionalTimeOption?.toSString(context) ?? ""),
        const Divider(thickness: 1, height: 30),
        Row(children: buttons),
      ],
    );
  }

  double _indexToValue(int index) =>
      Constants.minAirTempValue + (index * Constants.airTempStep);

  int _valueToIndex(double value) =>
      ((value - Constants.minAirTempValue) / Constants.airTempStep).round();

  void _onValueSelected(int index) {
    double value = _indexToValue(index);
    _calendar.additional != null
        ? _calendar.additional!.value = value
        : _calendar.additional = CalendarPoint(value: value);
  }

  Widget _tempScrollSetting() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: _scrollWidth,
          height: _scrollHeight,
          child: ListWheelScrollView(
            itemExtent: 70,
            overAndUnderCenterOpacity: 0.5,
            controller: _valController,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: _onValueSelected,
            children: List.generate(
                _valueToIndex(Constants.maxAirTempValue).round() + 1,
                (index) => Text(_indexToValue(index).toString().padLeft(2, '0'),
                    style: Constants.actualTempUnitStyle)),
          ),
        ),
        Text('°C', style: Constants.actualTempUnitStyle.copyWith(height: 0.6)),
      ],
    );
  }

  Widget _timeScrollSetting() {
    return SizedBox(
        height: _scrollHeight,
        child: Row(
          children: [
            Flexible(
              child: ListWheelScrollView(
                itemExtent: 70,
                controller: _hourController,
                overAndUnderCenterOpacity: 0.5,
                physics: const FixedExtentScrollPhysics(),
                onSelectedItemChanged: (h) => _calendar.additional!.hour = h,
                children: List.generate(
                    24,
                    (index) => Text(index.toString().padLeft(2, '0'),
                        style: Constants.actualTempUnitStyle)),
              ),
            ),
            Text(':',
                style: Constants.actualTempUnitStyle.copyWith(height: 0.6)),
            Flexible(
              child: ListWheelScrollView(
                itemExtent: 70,
                controller: _minController,
                overAndUnderCenterOpacity: 0.5,
                physics: const FixedExtentScrollPhysics(),
                onSelectedItemChanged: (m) => _calendar.additional!.min = m,
                children: List.generate(
                    60,
                    (index) => Text(index.toString().padLeft(2, '0'),
                        style: Constants.actualTempUnitStyle)),
              ),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    _buildContent();

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(S.of(context)!.additionalPoint),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: _onBackPress,
        ),
      ),
      body: SingleChildScrollView(
        padding: Constants.formPadding,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _contentList),
      ),
    ));
  }
}
