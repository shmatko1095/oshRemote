import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:osh_remote/block/thing_cubit/model/calendar/thing_calendar.dart';
import 'package:osh_remote/block/thing_cubit/thing_controller_cubit.dart';
import 'package:osh_remote/block/thing_cubit/thing_controller_state.dart';
import 'package:osh_remote/pages/home/temperature_setting/additional_point/additional_point.dart';
import 'package:osh_remote/pages/home/temperature_setting/antifreeze/antifreeze.dart';
import 'package:osh_remote/pages/home/temperature_setting/calendar_list/calendar_list.dart';
import 'package:osh_remote/pages/home/temperature_setting/manual/manual.dart';
import 'package:osh_remote/utils/constants.dart';
import 'package:osh_remote/utils/widget_helpers.dart';

class HomeTempIndicator extends StatelessWidget {
  static const kHeight = 550.0;

  const HomeTempIndicator({super.key});

  ThingCalendar _getCalendar(BuildContext context) =>
      context.read<ThingControllerCubit>().state.calendar!;

  void _onPress(BuildContext context) {
    switch (_getCalendar(context).currentMode) {
      case CalendarMode.manual:
        Navigator.of(context).push(Manual.route());
        break;
      case CalendarMode.antifreeze:
        Navigator.of(context).push(Antifreeze.route());
        break;
      case CalendarMode.daily:
      case CalendarMode.weekly:
        Navigator.of(context).push(CalendarList.route());
        break;
      case CalendarMode.off:
      default:
        break;
    }
  }

  void _onLongPress(BuildContext context) {
    Navigator.of(context).push(AdditionalPointScreen.route());
  }

  Color? _getColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Colors.white
        : null;
  }

  Widget _powerLimit(int val, int amount) {
    List<Widget> list = List.generate(
        amount,
        (index) => Icon(Icons.lens,
            size: 10, color: index < val ? Colors.red : Colors.grey));

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: list.map((widget) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: widget,
        );
      }).toList(),
    );
  }

  Widget _temp(double value, TextStyle tempStyle, TextStyle unitStyle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value.toString(), style: tempStyle),
        Text("°C", style: unitStyle),
      ],
    );
  }

  List<Widget> _buildContent(BuildContext context, ThingCalendar val) {
    final List<Widget> content = [];
    content.add(const Spacer(flex: 2));
    //@TODO: current temp should be instead of calendar
    content.add(_temp(val.current.value, Constants.actualTempStyle,
        Constants.actualTempUnitStyle));
    content.add(_temp(val.current.value, Constants.targetTempStyle,
        Constants.targetUnitTempStyle));
    if (val.next != null) {
      content.add(Text("${val.next!.value}°C ${S.of(context)!.at} "
          ""
          "${formatTime(val.next!.hour!, val.next!.min!)}"));
    }
    if (val.current.power != null) {
      final heaterConfig =
          context.read<ThingControllerCubit>().state.config!.heaterConfig;
      content.add(_powerLimit(val.current.power!, heaterConfig));
    }
    content.add(const Spacer());
    return content
        .expand((element) => [element, const SizedBox(height: 36)])
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => _onPress(context),
        onLongPress: () => _onLongPress(context),
        child: Container(
          alignment: Alignment.center,
          color: _getColor(context),
          height: kHeight,
          child: BlocBuilder<ThingControllerCubit, ThingControllerState>(
              buildWhen: (previous, current) =>
                  previous.calendar != current.calendar,
              builder: (context, st) {
                return Column(children: _buildContent(context, st.calendar!));
              }),
        ));
  }
}
