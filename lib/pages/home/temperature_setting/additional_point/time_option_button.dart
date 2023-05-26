part of 'additional_point.dart';

extension TimeOptionExtension on TimeOption {
  String toSString(BuildContext context) {
    switch (this) {
      case TimeOption.untilNextPoint:
        return S.of(context)!.untilNextPoint;
      case TimeOption.setupTime:
        return S.of(context)!.setupTime;
      case TimeOption.forHalfHour:
        return S.of(context)!.forHalfHour;
      case TimeOption.goToManual:
        return S.of(context)!.toManual;
    }
  }

  Widget toText(BuildContext context) {
    switch (this) {
      case TimeOption.untilNextPoint:
        return Text(S.of(context)!.untilNextPoint);
      case TimeOption.setupTime:
        return Text(S.of(context)!.setupTime);
      case TimeOption.forHalfHour:
        return Text(S.of(context)!.forHalfHour);
      case TimeOption.goToManual:
        return Text(S.of(context)!.toManual);
    }
  }

  Widget toIcon(BuildContext context) {
    switch (this) {
      case TimeOption.untilNextPoint:
        return const Icon(Icons.timeline);
      case TimeOption.setupTime:
        return const Icon(Icons.settings);
      case TimeOption.forHalfHour:
        return const Icon(Icons.timer);
      case TimeOption.goToManual:
        return const Icon(Icons.back_hand);
    }
  }
}
