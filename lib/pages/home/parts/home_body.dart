import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:osh_remote/block/thing_cubit/model/thing_data.dart';
import 'package:osh_remote/block/thing_cubit/thing_controller_cubit.dart';
import 'package:osh_remote/block/thing_cubit/thing_controller_state.dart';
import 'package:osh_remote/pages/home/drawer/drawer.dart';
import 'package:osh_remote/pages/home/parts/home_temp_indicator.dart';
import 'package:osh_remote/pages/home/parts/selector_mode_widget.dart';
import 'package:osh_remote/pages/home/parts/small_widget.dart';
import 'package:osh_remote/pages/home/stream_widget_adapter.dart';
import 'package:osh_remote/pages/settings/settings.dart';
import 'package:osh_remote/utils/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // late final Map<String, SmallHomeWidget> _indicatorList;
  late final ScrollController _scrollController;
  static const kExpandedHeight = 350.0;
  final _adapter = StreamWidgetAdapter();
  ThingData? _thingData;
  Widget? _title;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          // _title = _isSliverAppBarExpanded ? const Text("Title") : null;
          _title = _thingData != null ? Text(_thingData!.name) : null;
        });
      });

    context
        .read<ThingControllerCubit>()
        .widgetsStream
        .listen((jsonString) => _adapter.updateWidgets(jsonString));
  }

  bool _isThingChanged(
      ThingControllerState previous, ThingControllerState current) {
    // final previousIndex = previous.thingDataMap.values.toList().indexWhere(
    //     (element) => element.status == ThingConnectionStatus.connected);
    // final currentIndex = current.thingDataMap.values.toList().indexWhere(
    //     (element) => element.status == ThingConnectionStatus.connected);
    // return previousIndex != currentIndex;
    return previous.connectedThing != current.connectedThing;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _addWidgetsToAdapter();
  }

  bool get _isSliverAppBarExpanded {
    return _scrollController.hasClients &&
        _scrollController.offset > kExpandedHeight - kToolbarHeight;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ThingControllerCubit, ThingControllerState>(
      listenWhen: _isThingChanged,
      listener: (context, state) => setState(() {
        _thingData = state.connectedThing;
        _title = _thingData != null ? Text(_thingData!.name) : null;
      }),
      child: BlocBuilder<ThingControllerCubit, ThingControllerState>(
          buildWhen: _isThingChanged,
          builder: (context, state) => SafeArea(
              child: state.connectedThing != null
                  ? _getBody()
                  : _getNoThingPage())),
    );
  }

  Widget _getNoThingPage() {
    return Scaffold(
      drawer: const DrawerPresenter(),
      appBar: AppBar(
        title: const Text("OSH"),
        centerTitle: true,
      ),
      body: Center(
        child: Text(S.of(context)!.noConnectedDevice),
      ),
    );
  }

  Widget _getBody() {
    return Scaffold(
      drawer: const DrawerPresenter(),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverAppBar(
            title: _title,
            centerTitle: true,
            actions: [
              IconButton(
                  onPressed: () => Navigator.of(context).push(Settings.route()),
                  icon: const Icon(Icons.settings))
            ],
            pinned: true,
            expandedHeight: kExpandedHeight,
            flexibleSpace: FlexibleSpaceBar(
              background: HomeTempIndicator(
                  height: kExpandedHeight,
                  actualTemp: 25.2,
                  targetTemp: 25,
                  nextPointTemp: 30,
                  nextPointTime: DateTime(2022, 12, 10, 17, 20)),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SelectorModeWidget(),
              ],
            ),
          ),
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, mainAxisExtent: 120.0, //height
            ),
            delegate: SliverChildListDelegate(_adapter.getWidgetList()),
          ),
        ],
      ),
    );
  }

  void _addWidgetsToAdapter() {
    _adapter.add(
        Constants.keyHeaterStatus,
        SmallHomeWidget(
          label: S.of(context)!.heater_status,
          initial: "1/3",
          iconData: Icons.local_fire_department,
        ));

    _adapter.add(
        Constants.keyPumpStatus,
        SmallHomeWidget(
          label: S.of(context)!.pump_status,
          initial: "48",
          postfix: "%",
          iconData: Icons.loop,
        ));

    _adapter.add(
      Constants.keyWaterTempIn,
      SmallHomeWidget(
          label: S.of(context)!.temp_in,
          initial: "22.5",
          postfix: "°C",
          iconData: Icons.arrow_upward),
    );

    _adapter.add(
      Constants.keyWaterTempOut,
      SmallHomeWidget(
          label: S.of(context)!.temp_out,
          initial: "23.2",
          postfix: "°C",
          iconData: Icons.arrow_downward),
    );

    _adapter.add(
      Constants.keyWaterPressure,
      SmallHomeWidget(
          label: S.of(context)!.pressure,
          initial: "1.98",
          postfix: "bar",
          iconData: Icons.compare_arrows),
    );

    _adapter.add(
      Constants.keyPowerUsage,
      SmallHomeWidget(
          label: S.of(context)!.power_usage,
          initial: "61",
          postfix: "%",
          iconData: Icons.timelapse),
    );

    _adapter.add(
      Constants.keySwVerMajor,
      SmallHomeWidget(
          label: S.of(context)!.power_usage,
          initial: "61",
          postfix: "%",
          iconData: Icons.timelapse),
    );

    _adapter.add(
      Constants.keySwVerMinor,
      SmallHomeWidget(
          label: S.of(context)!.power_usage,
          initial: "61",
          postfix: "%",
          iconData: Icons.timelapse),
    );

    _adapter.add(
      Constants.keyHwVerMajor,
      SmallHomeWidget(
          label: S.of(context)!.power_usage,
          initial: "61",
          postfix: "%",
          iconData: Icons.timelapse),
    );

    _adapter.add(
      Constants.keyHwVerMinor,
      SmallHomeWidget(
          label: S.of(context)!.power_usage,
          initial: "61",
          postfix: "%",
          iconData: Icons.timelapse),
    );
  }
}
