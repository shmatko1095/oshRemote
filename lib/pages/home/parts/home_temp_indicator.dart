import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:osh_remote/block/thing_cubit/model/thing_calendar.dart';
import 'package:osh_remote/block/thing_cubit/thing_controller_cubit.dart';
import 'package:osh_remote/block/thing_cubit/thing_controller_state.dart';
import 'package:osh_remote/pages/home/parts/circle_widget.dart';
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
    content.add(_temp(val.currentPoint.value, Constants.actualTempStyle,
        Constants.actualTempUnitStyle));
    content.add(_temp(val.currentPoint.value, Constants.targetTempStyle,
        Constants.targetUnitTempStyle));
    if (val.nextPoint != null) {
      content.add(Text("${S.of(context)!.then} ${val.nextPoint!.value}°C "
          "${S.of(context)!.at} ${formatTime(val.nextPoint!.hour!, val.nextPoint!.min!)}"));
    }
    if (val.currentPoint.power != null) {
      final heaterConfig = context
          .read<ThingControllerCubit>()
          .state
          .connectedThing!
          .config!
          .heaterConfig;
      content.add(_powerLimit(val.currentPoint.power!, heaterConfig));
    }
    content.add(const Spacer());
    return content
        .expand((element) => [element, const SizedBox(height: 36)])
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => Navigator.of(context).push(Manual.route()),
        onLongPress: () {},

        ///@TODO Open screen to set transparent point
        child: Container(
          alignment: Alignment.center,
          color: _getColor(context),
          height: kHeight,
          child: BlocBuilder<ThingControllerCubit, ThingControllerState>(
              buildWhen: (previous, current) =>
                  previous.connectedThing?.calendar !=
                  current.connectedThing?.calendar,
              builder: (context, state) {
                final val = state.connectedThing!.calendar!;
                return Column(children: _buildContent(context, val));
              }),
        ));
  }
}
