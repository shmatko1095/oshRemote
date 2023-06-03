import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:osh_remote/block/thing_cubit/model/thing_data.dart';
import 'package:osh_remote/block/thing_cubit/thing_controller_cubit.dart';
import 'package:osh_remote/block/thing_cubit/thing_controller_state.dart';
import 'package:osh_remote/pages/home/drawer/drawer.dart';
import 'package:osh_remote/pages/home/parts/card_widget.dart';
import 'package:osh_remote/pages/home/parts/home_temp_indicator.dart';
import 'package:osh_remote/pages/home/parts/selector_mode_widget.dart';
import 'package:osh_remote/pages/settings/settings.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final ScrollController _scrollController;

  ThingData? get _thing =>
      context.read<ThingControllerCubit>().state.connectedThing;

  bool _isSliverAppBarExpandedPrevious = false;

  bool get _isSliverAppBarExpandedCurrent =>
      _scrollController.hasClients &&
      _scrollController.offset > HomeTempIndicator.kHeight - kToolbarHeight;

  Widget _title = const Text("OSH");

  Color _getTitleColor() {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? Colors.white : Colors.black;
  }

  void _updateTitle() {
    if (_thing == null) {
      _title = const Text("OSH");
    } else {
      //@TODO: current temp should be instead of maxTemp
      _title = _isSliverAppBarExpandedCurrent
          ? Text("${_thing!.name},  ${_thing!.settings!.waterTemp.maxTemp}°C")
          : Text(_thing!.name, style: TextStyle(color: _getTitleColor()));
    }
  }

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()
      ..addListener(() {
        if (_isSliverAppBarExpandedCurrent != _isSliverAppBarExpandedPrevious) {
          _isSliverAppBarExpandedPrevious = _isSliverAppBarExpandedCurrent;
          setState(() => _updateTitle());
        }
      });
  }

  bool _isThingChanged(
      ThingControllerState previous, ThingControllerState current) {
    return previous.connectedThing != current.connectedThing;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ThingControllerCubit, ThingControllerState>(
      listenWhen: _isThingChanged,
      listener: (context, state) => setState(() => _updateTitle()),
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
        title: _title,
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
            centerTitle: !_isSliverAppBarExpandedCurrent,
            iconTheme: IconThemeData(color: _getTitleColor()),
            actions: [
              IconButton(
                  onPressed: () => Navigator.of(context).push(Settings.route()),
                  icon: Icon(Icons.settings, color: _getTitleColor()))
            ],
            pinned: true,
            expandedHeight: HomeTempIndicator.kHeight,
            flexibleSpace: const FlexibleSpaceBar(
              background: HomeTempIndicator(),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SelectorModeWidget(),
              ],
            ),
          ),
          _cardWidgetList(),
        ],
      ),
    );
  }

  Widget _getWaitingPage() {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          const Center(heightFactor: 2, child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  Widget _getCardGrid(ThingControllerState state) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, mainAxisExtent: 120.0, //height
      ),
      delegate: SliverChildListDelegate(<Widget>[
        CardWidget(
            label: S.of(context)!.heater_status,
            value: "${state.info!.heaterStatus}/${state.config!.heaterConfig}",
            iconData: Icons.local_fire_department),
        CardWidget(
            label: S.of(context)!.pump_status,
            value: "${state.info!.pumpStatus}%",
            iconData: Icons.loop),
        CardWidget(
            label: S.of(context)!.temp_in,
            value: "${state.info!.tempIn}°C",
            iconData: Icons.arrow_upward),
        CardWidget(
            label: S.of(context)!.temp_out,
            value: "${state.info!.tempOut}°C",
            iconData: Icons.arrow_downward),
        CardWidget(
            label: S.of(context)!.pressure,
            value: "${state.info!.pressure}bar",
            iconData: Icons.opacity),
        CardWidget(
            label: S.of(context)!.power_usage,
            value: "${state.info!.powerUsage}%",
            iconData: Icons.timelapse),
      ]),
    );
  }

  Widget _cardWidgetList() {
    return BlocBuilder<ThingControllerCubit, ThingControllerState>(
        buildWhen: (p, c) => p.info != c.info,
        builder: (context, state) {
          if (state.info == null || state.config == null) {
            return _getWaitingPage();
          } else {
            return _getCardGrid(state);
          }
        });
  }
}
