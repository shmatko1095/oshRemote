part of 'edit_point.dart';

extension DaysPart on EditPointScreenState {
  Widget _daysSetting() {
    List<String> dayList = [];
    for (int i = 0; i < 7; i++) {
      if (isDaySelected(widget.point.day ?? 0, i)) {
        dayList.add(getDayName(context, i));
      }
    }

    String trailing() {
      if (widget.point.day == 0x7F) {
        return S.of(context)!.everyDay;
      } else if (widget.point.day == 0x00) {
        return S.of(context)!.never;
      } else {
        return dayList.join(",");
      }
    }

    return ListTile(
        title: Text(S.of(context)!.repeat),
        trailing: Text(trailing()),
        onTap: () => Navigator.of(context)
            .push(Days.route(cb: _onDaySelected, value: widget.point.day!)));
  }
}

class Days extends StatefulWidget {
  final int initValue;

  final Function(int mask) onConfirm;

  const Days({super.key, required this.onConfirm, required this.initValue});

  static Route<void> route(
      {required Function(int mask) cb, required int value}) {
    return MaterialPageRoute<void>(
        builder: (_) => Days(onConfirm: cb, initValue: value));
  }

  @override
  State createState() => _DaysState();
}

class _DaysState extends State<Days> {
  late int _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initValue;
  }

  void _onBackPress() {
    Navigator.of(context).pop();
  }

  void _onConfirm() {
    widget.onConfirm(_value);
    Navigator.of(context).pop();
  }

  Widget _dayBtn(String name, int dayBit) {
    return ElevatedButton(
      onPressed: () => setState(() => _value = toggleBit(_value, dayBit)),
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(24),
        backgroundColor:
            isDaySelected(_value, dayBit) ? null : Colors.grey.withOpacity(0.3),
      ),
      child: Text(name),
    );
  }

  List<Widget> generateList(int start, int len) {
    List<Widget> result = [];
    for (int i = start; i < start + len; i++) {
      result.add(_dayBtn(getDayName(context, i), i));
    }
    return result;
  }

  Widget _daySetting() {
    return SizedBox(
        width: 300,
        height: 400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: generateList(0, 2)),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: generateList(2, 3)),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: generateList(5, 2)),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(S.of(context)!.temp),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: _onBackPress,
        ),
      ),
      body: SingleChildScrollView(
        padding: Constants.formPadding,
        child: Column(
          children: [
            _daySetting(),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onConfirm,
                child: Text(S.of(context)!.confirm),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
