part of 'edit_point.dart';

extension TimePart on EditPointScreenState {
  Widget _timeScrollSetting() {
    return ListTile(
        title: Text(S.of(context)!.time),
        trailing: Text("${widget.point.hour.toString().padLeft(2, '0')} : "
            "${widget.point.min.toString().padLeft(2, '0')}"),
        onTap: () => Navigator.of(context).push(Time.route(
            _onTimeSelected, widget.point.hour!, widget.point.min!)));
  }
}

class Time extends StatefulWidget {
  final int initH;
  final int initM;

  final Function(int h, int m) onConfirm;

  const Time(
      {super.key,
      required this.onConfirm,
      required this.initH,
      required this.initM});

  static Route<void> route(Function(int h, int m) cb, int h, int m) {
    return MaterialPageRoute<void>(
        builder: (_) => Time(onConfirm: cb, initH: h, initM: m));
  }

  @override
  State createState() => _TimeState();
}

class _TimeState extends State<Time> {
  late int _h;
  late int _m;
  late FixedExtentScrollController _mController;
  late FixedExtentScrollController _hController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _m = widget.initM;
    _mController = FixedExtentScrollController(initialItem: _m);

    _h = widget.initH;
    _hController = FixedExtentScrollController(initialItem: _h);
  }

  void _onBackPress() {
    Navigator.of(context).pop();
  }

  void _onConfirm() {
    widget.onConfirm(_h, _m);
    Navigator.of(context).pop();
  }

  Widget _timeScrollSetting() {
    return SizedBox(
        height: 400,
        child: Row(
          children: [
            Flexible(
              child: ListWheelScrollView(
                itemExtent: 70,
                controller: _hController,
                overAndUnderCenterOpacity: 0.5,
                physics: const FixedExtentScrollPhysics(),
                onSelectedItemChanged: (h) => _h = h,
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
                controller: _mController,
                overAndUnderCenterOpacity: 0.5,
                physics: const FixedExtentScrollPhysics(),
                onSelectedItemChanged: (m) => _m = m,
                children: List.generate(
                    60,
                    (index) => Text(index.toString().padLeft(2, '0'),
                        style: Constants.actualTempUnitStyle)),
              ),
            ),
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
            _timeScrollSetting(),
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
