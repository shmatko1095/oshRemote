import 'package:flutter/material.dart';
import 'package:osh_remote/block/thing_cubit/model/calendar/calendar_point.dart';
import 'package:osh_remote/utils/constants.dart';
import 'package:osh_remote/utils/widget_helpers.dart';

class CalendarListTitle extends StatelessWidget {
  final int maxPower;
  final CalendarPoint point;
  final Function(CalendarPoint point) onEdit;
  final Function(CalendarPoint point) onRemove;

  const CalendarListTitle(
      {super.key,
      required this.point,
      required this.onEdit,
      required this.onRemove,
      required this.maxPower});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: Key(point.timeId.toString()),
        onDismissed: (dir) => onRemove(point),
        direction: DismissDirection.horizontal,
        background: Container(
            color: Colors.redAccent,
            alignment: Alignment.centerLeft,
            child: Row(children: const [
              Icon(Icons.delete),
              Spacer(),
              Icon(Icons.delete)
            ])),
        child: ListTile(
          onLongPress: () => onEdit(point),
          contentPadding:
              const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          title: Text(formatTime(point.hour!, point.min!),
              style: Constants.calendarListStyle),
          subtitle: point.day != null ? _dayList(point.day!, context) : null,
          trailing: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${point.value}°C', style: Constants.calendarListStyle),
              _powerLimit(point.power!, maxPower)
            ],
          ),
        ));
  }

  Widget _powerLimit(int val, int amount) {
    List<Widget> list = List.generate(
        amount,
        (index) => Icon(Icons.lens,
            size: 10, color: index < val ? Colors.red : Colors.grey));

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: list.map((widget) {
        return Padding(
          padding: const EdgeInsets.only(right: 3, left: 3),
          child: widget,
        );
      }).toList(),
    );
  }

  Widget _dayList(int val, BuildContext context) {
    List<Widget> list = List.generate(7, (index) {
      return Text("${getDayName(context, index)} ",
          style: TextStyle(
              color: isDaySelected(val, index) ? Colors.blue : Colors.grey));
    });
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: list);
  }
}
