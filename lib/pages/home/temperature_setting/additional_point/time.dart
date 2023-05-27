part of 'additional_point.dart';

extension Time on AdditionalPointScreenState {
  Widget _timeOptionButtons() {
    List<Widget> buttons = [];
    for (var element in TimeOption.values) {
      buttons.add(Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: ClipOval(
            child: Material(
                color: Colors.blue.withOpacity(
                    _calendar.additionalTimeOption == element ? 1 : 0.2),
                child: InkWell(
                  onTap: () => _onTimeOptionPressed(element),
                  child: SizedBox(
                      width: 50, height: 50, child: element.toIcon(context)),
                )),
          )));
    }
    buttons = buttons
        .expand((element) => (buttons.indexOf(element) != buttons.length - 1)
            ? [element, const Spacer()]
            : [element])
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
            title: Text(_calendar.additionalTimeOption.toSString(context))),
        Row(children: buttons),
      ],
    );
  }

  Widget _timeScrollSetting() {
    return SizedBox(
        height: _scrollHeight,
        child: Row(
          children: [
            Flexible(
              child: ListWheelScrollView(
                itemExtent: 70,
                controller: _hourController,
                overAndUnderCenterOpacity: 0.5,
                physics: const FixedExtentScrollPhysics(),
                onSelectedItemChanged: (h) => _calendar.additional!.hour = h,
                children: List.generate(
                    24,
                    (index) => Text(index.toString().padLeft(2, '0'),
                        style: Constants.actualTempUnitStyle)),
              ),
            ),
            Text(':',
                style: Constants.actualTempUnitStyle.copyWith(height: 0.6)),
            Flexible(
              child: ListWheelScrollView(
                itemExtent: 70,
                controller: _minController,
                overAndUnderCenterOpacity: 0.5,
                physics: const FixedExtentScrollPhysics(),
                onSelectedItemChanged: (m) => _calendar.additional!.min = m,
                children: List.generate(
                    60,
                    (index) => Text(index.toString().padLeft(2, '0'),
                        style: Constants.actualTempUnitStyle)),
              ),
            ),
          ],
        ));
  }

  Widget _timeOptionSettings() {
    List<Widget> widgets = [];

    widgets.add(_timeOptionButtons());
    if (_calendar.additionalTimeOption == TimeOption.setupTime) {
      widgets.add(_timeScrollSetting());
    }

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: widgets);
  }
}
