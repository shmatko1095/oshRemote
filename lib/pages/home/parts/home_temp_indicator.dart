import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:osh_remote/block/thing_cubit/model/thing_calendar.dart';
import 'package:osh_remote/block/thing_cubit/thing_controller_cubit.dart';
import 'package:osh_remote/block/thing_cubit/thing_controller_state.dart';
import 'package:osh_remote/pages/home/parts/circle_widget.dart';
import 'package:osh_remote/pages/home/temperature_setting/additional_point/additional_point.dart';
import 'package:osh_remote/pages/home/temperature_setting/manual/manual.dart';
import 'package:osh_remote/utils/constants.dart';

/// В зависимости от мода, что берется из кубита, нуоюходимо перестраивать виджет.
/// Например в Офф моде отобрадать только текущую,а В антизамерзании текущуюи и
/// диапазон температур, в суточном/недельном - текущую, установленную и след.точку.
///
/// При надании на значение открывать окно с:
/// 1) отлодить старт на время
/// 2) выключить на время
/// 3) изменить температуру (с выбором до след точки или в ручной режим)
///
///

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
        // TODO: Handle this case.
        break;
      case CalendarMode.daily:
        // TODO: Handle this case.
        break;
      case CalendarMode.weekly:
        // TODO: Handle this case.
        break;
      case CalendarMode.off:
      default:
        // TODO: Handle this case.
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
        (index) => CircleWidget(
            radius: 5,
            color: index < val ? Colors.deepOrangeAccent : Colors.grey));

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

  String formatTime(int hours, int minutes) {
    DateTime time = DateTime(0, 1, 1, hours, minutes);
    String formattedTime =
        "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
    return formattedTime;
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
