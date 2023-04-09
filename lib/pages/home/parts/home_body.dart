import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:osh_remote/block/mqtt_client/mqtt_client_bloc.dart';
import 'package:osh_remote/models/mqtt_message_header.dart';
import 'package:osh_remote/pages/home/parts/home_temp_indicator.dart';
import 'package:osh_remote/pages/home/parts/selector_mode_widget.dart';
import 'package:osh_remote/pages/home/parts/small_widget.dart';
import 'package:osh_remote/pages/home/stream_widget_adapter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ScrollController _scrollController;
  static const kExpandedHeight = 350.0;
  final _adapter = StreamWidgetAdapter();
  Widget? _title;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          _title = _isSliverAppBarExpanded ? const Text("Title") : null;
        });
      });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    addWidgetsToAdapter();

    // _adapter.getTopicList().forEach((desc) {
    //   BlocProvider.of<MqttClientBloc>(context).add(
    //       MqttSubscribeRequestedEvent(desc: desc));
    // });

    BlocProvider.of<MqttClientBloc>(context).mqttMessageStream.listen((event) {
      _adapter.notifyWidget(event.header, event.message);
    });
  }

  bool get _isSliverAppBarExpanded {
    return _scrollController.hasClients &&
        _scrollController.offset > kExpandedHeight - kToolbarHeight;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MqttClientBloc, MqttClientState>(
      buildWhen: (previous, current) =>
          previous.connectionState != current.connectionState,
      builder: (context, state) {
        // if (state.connectionState == MqttClientConnectionStatus.connected) {
        return _getBody();
        // } else {
        //   return const SplashPage();
        // }
      },
    );
  }

  void addWidgetsToAdapter() {
    _adapter.add(
        const MqttMessageHeader("0"),
        SmallHomeWidget(
          label: S.of(context)!.heater_status,
          initial: "1/3",
          iconData: Icons.local_fire_department,
        ));

    _adapter.add(
        const MqttMessageHeader("1"),
        SmallHomeWidget(
          label: S.of(context)!.pump_status,
          initial: "48",
          postfix: "%",
          iconData: Icons.loop,
        ));

    _adapter.add(
      const MqttMessageHeader("2"),
      SmallHomeWidget(
          label: S.of(context)!.temp_in,
          initial: "22.5",
          postfix: "°C",
          iconData: Icons.arrow_upward),
    );

    _adapter.add(
      const MqttMessageHeader("3"),
      SmallHomeWidget(
          label: S.of(context)!.temp_out,
          initial: "23.2",
          postfix: "°C",
          iconData: Icons.arrow_downward),
    );

    _adapter.add(
      const MqttMessageHeader("4"),
      SmallHomeWidget(
          label: S.of(context)!.pressure,
          initial: "1.98",
          postfix: "bar",
          iconData: Icons.compare_arrows),
    );

    _adapter.add(
      const MqttMessageHeader("5"),
      SmallHomeWidget(
          label: S.of(context)!.power_usage,
          initial: "61",
          postfix: "%",
          iconData: Icons.timelapse),
    );

    _adapter.add(
      const MqttMessageHeader("6"),
      SmallHomeWidget(
          label: S.of(context)!.pressure,
          postfix: "bar",
          iconData: Icons.compare_arrows),
    );

    _adapter.add(
      const MqttMessageHeader("7"),
      SmallHomeWidget(
          label: S.of(context)!.power_usage,
          postfix: "%",
          iconData: Icons.timelapse),
    );

    _adapter.add(
      const MqttMessageHeader("8"),
      SmallHomeWidget(
          label: S.of(context)!.pressure,
          postfix: "bar",
          iconData: Icons.compare_arrows),
    );

    _adapter.add(
      const MqttMessageHeader("9"),
      SmallHomeWidget(
          label: S.of(context)!.power_usage,
          postfix: "%",
          iconData: Icons.timelapse),
    );
  }

  Widget _getBody() {
    return CustomScrollView(
      controller: _scrollController,
      slivers: <Widget>[
        SliverAppBar(
          title: _title,
          centerTitle: true,
          actions: [
            IconButton(onPressed: () => {}, icon: const Icon(Icons.settings))
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
      // )
    );
  }
}
