part of 'additional_point.dart';

extension Temp on AdditionalPointScreenState {
  // double _indexToValue(int index) =>
  //     Constants.minAirTempValue + (index * Constants.airTempStep);
  //
  // int _valueToIndex(double value) =>
  //     ((value - Constants.minAirTempValue) / Constants.airTempStep).round();

  void _onValueSelected(int index) {
    double value = indexToValue(index);
    _calendar.additional != null
        ? _calendar.additional!.value = value
        : _calendar.additional = CalendarPoint(value: value);
  }

  Widget _tempScrollSetting() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: _scrollWidth,
          height: _scrollHeight,
          child: ListWheelScrollView(
            itemExtent: 70,
            overAndUnderCenterOpacity: 0.5,
            controller: _valController,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: _onValueSelected,
            children: List.generate(
                valueToIndex(Constants.maxAirTempValue).round() + 1,
                (index) => Text(indexToValue(index).toString().padLeft(2, '0'),
                    style: Constants.actualTempUnitStyle)),
          ),
        ),
        Text('°C', style: Constants.actualTempUnitStyle.copyWith(height: 0.6)),
      ],
    );
  }
}
