import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:osh_remote/block/thing_cubit/model/calendar/calendar_point.dart';
import 'package:osh_remote/block/thing_cubit/thing_controller_cubit.dart';
import 'package:osh_remote/pages/home/temperature_setting/weekly/calendar_list_title.dart';
import 'package:osh_remote/utils/constants.dart';
import 'package:osh_remote/utils/widget_helpers.dart';

class CalendarList extends StatefulWidget {
  final List<CalendarPoint> points;

  const CalendarList({required this.points, super.key});

  static Route<void> route(List<CalendarPoint> list) {
    return MaterialPageRoute<void>(builder: (_) => CalendarList(points: list));
  }

  @override
  State createState() => _CalendarListState();
}

class _CalendarListState extends State<CalendarList> {
  int _dayFilter = 0x7F;
  late List<CalendarPoint> _points;

  void _updateLocalPoints() {
    _points = List.from(widget.points);
    _points.sort();
    _points = _points.where((element) {
      if (element.day != null) {
        return _dayFilter & element.day! != 0;
      } else {
        return true;
      }
    }).toList();
  }

  void _onBackPress() {
    context.read<ThingControllerCubit>().pushWeeklyCalendar();
    Navigator.of(context).pop();
  }

  void _onAdd() {}

  void _onRemove(CalendarPoint point) {
    setState(() {
      widget.points.removeWhere((element) => element.timeId == point.timeId);
    });
  }

  void _onEdit(CalendarPoint point) {
    setState(() {});
  }

  void _onDayPressed(int index) {
    int toggleBit(int number, int index) {
      int mask = 1 << index;
      return number ^ mask;
    }

    setState(() {
      _dayFilter = toggleBit(_dayFilter, index);
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

  bool _isDaySelectorRequired() {
    return widget.points.any((element) => element.day != null);
  }

  @override
  Widget build(BuildContext context) {
    _updateLocalPoints();

    return SafeArea(
      child: Scaffold(
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
                      .config!
                      .heaterConfig,
                  onEdit: _onEdit,
                  onRemove: _onRemove,
                )),
        persistentFooterAlignment: AlignmentDirectional.bottomCenter,
        persistentFooterButtons:
            _isDaySelectorRequired() ? [_daySelector(context)] : null,
      ),
    );
  }
}
