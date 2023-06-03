import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:osh_remote/block/thing_cubit/model/calendar/calendar_point.dart';
import 'package:osh_remote/block/thing_cubit/model/thing_calendar.dart';
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
  late List<CalendarPoint> _points;
  late CalendarMode _mode;

  ThingCalendar get _calendar {
    return context.read<ThingControllerCubit>().state.calendar!;
  }

  List<CalendarPoint>? get _calendarPoints {
    if (_mode == CalendarMode.daily) {
      return context.read<ThingControllerCubit>().state.calendar?.daily;
    } else if (_mode == CalendarMode.weekly) {
      return context.read<ThingControllerCubit>().state.calendar?.weekly;
    } else {
      throw StateError("_mode invalid value");
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _mode = _calendar.currentMode;

    _updateLocalPoints();
  }

  void _onCalendarChange(BuildContext context, ThingControllerState state) {
    if (state.calendar == null) {
      Navigator.of(context).pop();
    } else {
      setState(() => _updateLocalPoints());
    }
  }

  void _updateLocalPoints() {
    _points = List.from(_calendarPoints ?? []);
    _points.sort();
    _points = _points.where((element) {
      if (element.day == null || element.day! == 0) {
        return true;
      } else {
        return (_dayFilter & element.day! != 0);
      }
    }).toList();
  }

  void _onBackPress() {
    if (_mode == CalendarMode.daily) {
      context.read<ThingControllerCubit>().pushDailyCalendar();
    } else if (_mode == CalendarMode.weekly) {
      context.read<ThingControllerCubit>().pushWeeklyCalendar();
    }
    Navigator.of(context).pop();
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
              _calendarPoints?.add(newPoint);
            })));
  }

  void _onEdit(CalendarPoint point) {
    Navigator.of(context)
        .push(EditPointScreen.route(point, _mode, (_) => setState(() {})));
  }

  void _onRemove(CalendarPoint point) {
    setState(() {
      _calendarPoints?.removeWhere((element) => element.timeId == point.timeId);
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
      child: BlocListener<ThingControllerCubit, ThingControllerState>(
          listenWhen: (p, c) => p.calendar != c.calendar,
          listener: _onCalendarChange,
          child: BlocBuilder<ThingControllerCubit, ThingControllerState>(
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
                              point: _points[index],
                              maxPower: context
                                  .read<ThingControllerCubit>()
                                  .state
                                  .config?.heaterConfig ?? 0,
                              onEdit: _onEdit,
                              onRemove: _onRemove,
                            )),
                    persistentFooterAlignment:
                        AlignmentDirectional.bottomCenter,
                    persistentFooterButtons: _mode == CalendarMode.weekly
                        ? [_daySelector(context)]
                        : null,
                  ))),
    );
  }
}
