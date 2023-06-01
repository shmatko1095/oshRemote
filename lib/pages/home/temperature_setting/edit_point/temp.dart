part of 'edit_point.dart';

extension TempPart on EditPointScreenState {
  Widget _tempScrollSetting() {
    return ListTile(
        title: Text(S.of(context)!.temp),
        trailing: Text("${widget.point.value}°C"),
        onTap: () => Navigator.of(context)
            .push(Temp.route(_onValueSelected, widget.point.value)));
  }
}

class Temp extends StatefulWidget {
  final double initValue;

  final Function(double point) onConfirm;

  const Temp({super.key, required this.onConfirm, required this.initValue});

  static Route<void> route(Function(double point) cb, double initValue) {
    return MaterialPageRoute<void>(
        builder: (_) => Temp(onConfirm: cb, initValue: initValue));
  }

  @override
  State createState() => _TempState();
}

class _TempState extends State<Temp> {
  late double _value;
  late FixedExtentScrollController _scrollController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _value = widget.initValue;
    _scrollController =
        FixedExtentScrollController(initialItem: valueToIndex(_value));
  }

  void _onBackPress() {
    Navigator.of(context).pop();
  }

  void _onConfirm() {
    widget.onConfirm(_value);
    Navigator.of(context).pop();
  }

  void _onValueSelected(int index) => _value = indexToValue(index);

  Widget _tempScrollSetting() {
    return SizedBox(
      height: 400,
      width: 205,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: ListWheelScrollView(
              itemExtent: 70,
              overAndUnderCenterOpacity: 0.5,
              controller: _scrollController,
              physics: const FixedExtentScrollPhysics(),
              onSelectedItemChanged: _onValueSelected,
              children: List.generate(
                  valueToIndex(Constants.maxAirTempValue).round() + 1,
                  (index) => Text(
                      indexToValue(index).toString().padLeft(2, '0'),
                      style: Constants.actualTempUnitStyle)),
            ),
          ),
          const Flexible(
            child: Text('°C',
                style: TextStyle(
                    fontSize: 50, fontWeight: FontWeight.w300, height: 0.7)),
          )
        ],
      ),
    );
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
            _tempScrollSetting(),
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
