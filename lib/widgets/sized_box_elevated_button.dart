import 'package:flutter/material.dart';

class SizedBoxElevatedButton extends StatelessWidget {
  final Text text;
  final Function()? Function() onPressed;

  const SizedBoxElevatedButton(
      {required this.text, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed(),
        child: text,
      ),
    );
  }
}
