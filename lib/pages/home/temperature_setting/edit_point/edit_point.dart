import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:osh_remote/block/thing_cubit/model/calendar/calendar_point.dart';
import 'package:osh_remote/block/thing_cubit/model/thing_calendar.dart';
import 'package:osh_remote/block/thing_cubit/model/thing_config.dart';
import 'package:osh_remote/block/thing_cubit/thing_controller_cubit.dart';
import 'package:osh_remote/utils/constants.dart';
import 'package:osh_remote/utils/widget_helpers.dart';
import 'package:osh_remote/widgets/sized_box_elevated_button.dart';

part 'days.dart';
part 'power_limit.dart';
part 'temp.dart';
part 'time.dart';

class EditPointScreen extends StatefulWidget {
  final CalendarMode mode;
  final CalendarPoint point;
  final void Function(CalendarPoint point) onConfirm;

  const EditPointScreen(
      {super.key,
      required this.point,
      required this.mode,
      required this.onConfirm});

  static Route<void> route(CalendarPoint init, CalendarMode mode,
      void Function(CalendarPoint point) onConfirm) {
    return MaterialPageRoute<void>(
        builder: (_) =>
            EditPointScreen(point: init, mode: mode, onConfirm: onConfirm));
  }

  @override
  State createState() => EditPointScreenState();
}

class EditPointScreenState extends State<EditPointScreen> {
  List<Widget> _contentList = [];

  ThingConfig get _config => context.read<ThingControllerCubit>().state.config!;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void _buildContent() {
    _contentList.clear();
    _contentList.add(_tempScrollSetting());
    _contentList.add(_timeScrollSetting());
    if (widget.mode == CalendarMode.weekly) {
      _contentList.add(_daysSetting());
    }
    _contentList.add(powerLimitSettings());
    _contentList.add(_confirmButton());

    _contentList = _contentList.expand((element) {
      if (_contentList.indexOf(element) != _contentList.length - 1) {
        return [element, const Divider()];
      } else {
        return [element];
      }
    }).toList();
  }

  void _onValueSelected(double val) => setState(() => widget.point.value = val);

  void _onTimeSelected(int h, int m) => setState(() {
        widget.point.hour = h;
        widget.point.min = m;
      });

  void _onDaySelected(int dayMask) =>
      setState(() => widget.point.day = dayMask);

  void _onPowerLimitValueChanged(double value) {
    int val = value.round();
    if (val >= Constants.minHeaterConfig.toDouble()) {
      setState(() => widget.point.power = val);
    }
  }

  void _onBackPress() {
    Navigator.of(context).pop();
  }

  void _onConfirm() {
    widget.onConfirm(widget.point);
    Navigator.of(context).pop();
  }

  Widget _confirmButton() {
    return Padding(
        padding: Constants.formPadding,
        child: SizedBoxElevatedButton(
            text: Text(S.of(context)!.confirm), onPressed: () => _onConfirm));
  }

  @override
  Widget build(BuildContext context) {
    _buildContent();

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(S.of(context)!.temperaturePoint),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: _onBackPress,
        ),
      ),
      body: SingleChildScrollView(
        padding: Constants.listPadding,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _contentList),
      ),
    ));
  }
}
