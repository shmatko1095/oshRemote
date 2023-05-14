import 'package:flutter/material.dart';

Color getColor(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark
      ? Colors.white
      : Colors.black;
}