import 'package:flutter/material.dart';

class HomeTempIndicator extends StatefulWidget {
  const HomeTempIndicator({super.key});

  @override
  State<HomeTempIndicator> createState() => _HomeTempIndicatorState();
}

class _HomeTempIndicatorState extends State<HomeTempIndicator> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Theme.of(context).brightness == Brightness.light
          ? Colors.white
          : null,
      height: 300.0,
      child: Column(
        children: const <Widget>[
          Spacer(flex: 1),
          Text("25.2°C", style: _actualStyle),
          Text("25.2°C", style: _targetStyle),
          Text("next point 25.0°C at 17:30", style: _nextPointStyle),
          Spacer(flex: 1),
        ],
      ),
    );
  }
}

const TextStyle _actualStyle = TextStyle(fontSize: 64);
const TextStyle _targetStyle = TextStyle(fontSize: 32);
const TextStyle _nextPointStyle = TextStyle(fontSize: 16);
