import 'package:flutter/material.dart';

class HomeTempIndicator extends StatelessWidget {
  final double height;
  final double actualTemp;
  final double targetTemp;
  final double nextPointTemp;
  final DateTime nextPointTime;

  const HomeTempIndicator(
      {super.key,
      required this.height,
      required this.actualTemp,
      required this.targetTemp,
      required this.nextPointTemp,
      required this.nextPointTime});

  // Color? _getColor(BuildContext context) {
  //   return Theme.of(context).brightness == Brightness.light
  //       ? Colors.white
  //       : null;
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      // color: _getColor(context),
      height: height,
      child: Column(children: <Widget>[
        const Spacer(flex: 1),
        Text('$actualTemp°C', style: _actualStyle),
        const SizedBox(height: 24),
        Text('$targetTemp°C', style: _targetStyle),
        const SizedBox(height: 24),
        Text(
            'next $nextPointTemp°C at ${TimeOfDay.fromDateTime(nextPointTime).format(context)}'),
        const Spacer(flex: 1),
      ]),
    );
  }
}

const TextStyle _actualStyle = TextStyle(fontSize: 70);
const TextStyle _targetStyle = TextStyle(fontSize: 32);
// const TextStyle _nextPointStyle = TextStyle(fontSize: 16);
