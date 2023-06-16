import 'package:flutter/cupertino.dart';

class CircleWidget extends StatelessWidget {
  final double radius;
  final Color color;

  const CircleWidget({super.key, required this.radius, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}
