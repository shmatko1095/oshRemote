import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:osh_remote/block/thing_cubit/model/calendar/calendar_point.dart';
import 'package:osh_remote/block/thing_cubit/model/calendar/thing_calendar.dart';
import 'package:osh_remote/block/thing_cubit/model/thing_config.dart';
import 'package:osh_remote/block/thing_cubit/model/time_option.dart';
import 'package:osh_remote/block/thing_cubit/thing_controller_cubit.dart';
import 'package:osh_remote/utils/constants.dart';
import 'package:osh_remote/widgets/sized_box_elevated_button.dart';

import '../../../../utils/widget_helpers.dart';

part 'power_limit.dart';
part 'temp.dart';
part 'time.dart';
part 'time_option_button.dart';

class AdditionalPointScreen extends StatefulWidget {
  const AdditionalPointScreen({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(
        builder: (_) => const AdditionalPointScreen());
  }

  @override
  State createState() => AdditionalPointScreenState();
}

class AdditionalPointScreenState extends State<AdditionalPointScreen> {
  late FixedExtentScrollController _valController;
  late FixedExtentScrollController _minController;
  late FixedExtentScrollController _hourController;

  final _scrollHeight = 200.0;
  final _scrollWidth = 130.0;
  List<Widget> _contentList = [];

  ThingCalendar get _calendar =>
      context.read<ThingControllerCubit>().state.calendar!;

  ThingConfig get _config => context.read<ThingControllerCubit>().state.config!;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _calendar.additional == null
        ? _calendar.additional = CalendarPoint(
            value: _calendar.current.value, power: _config.heaterConfig)
        : _calendar.additional!.value = _calendar.current.value;

    _updateControllers();
  }

  void _updateControllers() {
    _valController = FixedExtentScrollController(
        initialItem: valueToIndex(_calendar.additional!.value));
    _minController = FixedExtentScrollController(
        initialItem: _calendar.additional!.min ?? 0);
    _hourController = FixedExtentScrollController(
        initialItem: _calendar.additional!.hour ?? 0);
  }

  void _buildContent() {
    _updateControllers();

    _contentList.clear();
    _contentList.add(_tempScrollSetting());
    _contentList.add(_timeOptionSettings());
    _contentList.add(powerLimitSettings());
    _contentList.add(_confirmButton());

    _contentList = _contentList.expand((element) {
      if (_contentList.indexOf(element) != _contentList.length - 1) {
        return [element, const Divider(thickness: 1, height: 50)];
      } else {
        return [element];
      }
    }).toList();
  }

  void _onPowerLimitValueChanged(double value) {
    int val = value.round();
    if (val >= Constants.minHeaterConfig.toDouble()) {
      setState(() => _calendar.additional!.power = val);
    }
  }

  void _onTimeOptionPressed(TimeOption val) {
    setState(() {
      _calendar.additionalTimeOption = val;
    });
  }

  void _onBackPress() {
    Navigator.of(context).pop();
  }

  void _onConfirm() {
    context.read<ThingControllerCubit>().setAdditionalPoint();
    Navigator.of(context).pop();
  }

  Widget _confirmButton() {
    return SizedBoxElevatedButton(
        text: Text(S.of(context)!.confirm), onPressed: () => _onConfirm);
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
        // padding: const EdgeInsets.only(left: 10, right: 10, top: 48, bottom: 16),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _contentList),
      ),
    ));
  }
}
