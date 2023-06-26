import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:osh_remote/block/thing_cubit/model/calendar/calendar_point.dart';
import 'package:osh_remote/block/thing_cubit/model/calendar/thing_calendar.dart';
import 'package:osh_remote/block/thing_cubit/thing_controller_cubit.dart';
import 'package:osh_remote/block/thing_cubit/thing_controller_state.dart';
import 'package:osh_remote/pages/home/temperature_setting/calendar_list/calendar_list_title.dart';
import 'package:osh_remote/pages/home/temperature_setting/edit_point/edit_point.dart';
import 'package:osh_remote/utils/constants.dart';
import 'package:osh_remote/utils/widget_helpers.dart';

class CalendarList extends StatefulWidget {
  const CalendarList({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const CalendarList());
  }

  @override
  State createState() => _CalendarListState();
}

class _CalendarListState extends State<CalendarList> {
  int _dayFilter = 0x7F;
  late Map<int, CalendarPoint> _points;
  late CalendarMode _mode;

  ThingCalendar get _calendar {
    return context.read<ThingControllerCubit>().state.calendar!;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _mode = _calendar.currentMode;

    _updateLocalPoints();
  }

  void _updateLocalPoints() {
    _points = Map.from(_calendarPoints ?? {});

    List<int> keys = _points.keys.toList()..sort();
    _points = Map.fromEntries(keys.map((key) => MapEntry(key, _points[key]!)));
    _points.removeWhere((key, value) {
      bool res = false;
      if (value.day != null) {
        if (value.day! != 0) res = (_dayFilter & value.day! == 0);
      }
      return res;
    });
  }

  void _onBackPress() {
    if (_mode == CalendarMode.daily) {
      context.read<ThingControllerCubit>().pushDailyCalendar();
    } else if (_mode == CalendarMode.weekly) {
      context.read<ThingControllerCubit>().pushWeeklyCalendar();
    }
    Navigator.of(context).pop();
  }

  Map<int, CalendarPoint>? get _calendarPoints {
    if (_mode == CalendarMode.daily) {
      return context.read<ThingControllerCubit>().state.calendar?.daily;
    } else if (_mode == CalendarMode.weekly) {
      return context.read<ThingControllerCubit>().state.calendar?.weekly;
    } else {
      throw StateError("_mode invalid value");
    }
  }

  void _onAdd() {
    final newPoint = CalendarPoint(
        value: _calendar.current.value,
        min: _calendar.current.min ?? 0,
        hour: _calendar.current.hour ?? 0,
        day: _calendar.currentMode == CalendarMode.weekly ? 0x7F : null,
        power: context.read<ThingControllerCubit>().state.config!.heaterConfig);

    Navigator.of(context).push(EditPointScreen.route(
        newPoint,
        _mode,
        (newPoint) => setState(() {
              _calendarPoints?[newPoint.timeId] = newPoint;
              _updateLocalPoints();
            })));
  }

  void _onEdit(CalendarPoint point) {
    Navigator.of(context).push(EditPointScreen.route(
        point, _mode, (_) => setState(_updateLocalPoints)));
  }

  void _onRemove(CalendarPoint point) {
    setState(() {
      _calendarPoints?.remove(point.timeId);
      _updateLocalPoints();
    });
  }

  void _onDayPressed(int index) {
    setState(() {
      _dayFilter = toggleBit(_dayFilter, index);
      _updateLocalPoints();
    });
  }

  Widget _daySelector(BuildContext context) {
    return Wrap(
        alignment: WrapAlignment.center,
        children: List.generate(
            7,
            (index) => IconButton(
                  onPressed: () => _onDayPressed(index),
                  icon: Text(getDayName(context, index),
                      style: TextStyle(
                          color: isDaySelected(_dayFilter, index)
                              ? Colors.blue
                              : Colors.grey)),
                )));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<ThingControllerCubit, ThingControllerState>(
          buildWhen: (p, c) => p.calendar != c.calendar,
          builder: (context, state) => Scaffold(
                appBar: AppBar(
                  title: Text(S.of(context)!.temp),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: _onBackPress,
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => _onAdd(),
                    ),
                  ],
                ),
                body: ListView.builder(
                    padding: Constants.listPadding,
                    itemCount: _points.length,
                    itemBuilder: (context, index) => CalendarListTitle(
                          point: _points.values.toList()[index],
                          maxPower: context
                                  .read<ThingControllerCubit>()
                                  .state
                                  .config
                                  ?.heaterConfig ??
                              0,
                          onEdit: _onEdit,
                          onRemove: _onRemove,
                        )),
                persistentFooterAlignment: AlignmentDirectional.bottomCenter,
                persistentFooterButtons: _mode == CalendarMode.weekly
                    ? [_daySelector(context)]
                    : null,
              )),
    );
  }
}
