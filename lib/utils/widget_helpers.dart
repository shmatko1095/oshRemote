import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Color getColor(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark
      ? Colors.white
      : Colors.black;
}

String formatTime(int hours, int minutes) {
  DateTime time = DateTime(0, 1, 1, hours, minutes);
  String formattedTime =
      "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  return formattedTime;
}

String getDayName(BuildContext context, int dayNum) {
  switch (dayNum) {
    case 0:
      return S.of(context)!.mo;
    case 1:
      return S.of(context)!.tu;
    case 2:
      return S.of(context)!.we;
    case 3:
      return S.of(context)!.th;
    case 4:
      return S.of(context)!.fr;
    case 5:
      return S.of(context)!.sa;
    case 6:
      return S.of(context)!.su;
    default:
      throw ArgumentError("Invalid day");
  }
}

bool isDaySelected(int val, int index) => (val & (1 << index)) != 0;
