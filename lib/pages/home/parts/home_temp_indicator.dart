import 'package:flutter/material.dart';

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

  // DateTime(2022, 12, 10, 17, 20);
  static const kHeight = 550.0;

  const HomeTempIndicator({super.key});

  Color? _getColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Colors.white
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: _getColor(context),
      height: kHeight,
      child: Column(children: <Widget>[
        const Spacer(flex: 1),
        const Text('25.0°C', style: _actualStyle),
        const SizedBox(height: 48),
        const Text('25.3°C', style: _targetStyle),
        // const SizedBox(height: 48),
        const Spacer(),
        Text('next 22.0°C at ${TimeOfDay.fromDateTime(DateTime(2022, 12, 10, 17, 20)).format(context)}'),
        const SizedBox(height: 24),
        // const Spacer(flex: 1),
        //@TODO: Add power limit indicator here
      ]),
    );
  }
}

const TextStyle _actualStyle = TextStyle(fontSize: 70);
const TextStyle _targetStyle = TextStyle(fontSize: 32);
// const TextStyle _nextPointStyle = TextStyle(fontSize: 16);
