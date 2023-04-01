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

    _adapter.add(
        const MqttMessageHeader("In1", 1),
        SmallHomeWidget(
          label: S.of(context)!.heater_status,
          iconData: Icons.local_fire_department,
        ));

    _adapter.add(
        const MqttMessageHeader("In2", 1),
        SmallHomeWidget(
          label: S.of(context)!.pump_status,
          iconData: Icons.loop,
        ));

    _adapter.getTopicList().forEach((desc) {
      BlocProvider.of<MqttClientBloc>(context)
          .add(MqttSubscribeRequestedEvent(desc: desc));
    });

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
          delegate: SliverChildListDelegate(_adapter.getWidgetList()
              // [
              //   SmallHomeWidget(
              //       label: S.of(context)!.heater_status,
              //       value: "1/6",
              //       iconData: Icons.local_fire_department,
              //     inStream: BlocProvider.of<MqttClientBloc>(context).,
              // ),
              // SmallHomeWidget(
              //     label: S.of(context)!.pump_status,
              //     value: "46%",
              //     iconData: Icons.loop),
              // SmallHomeWidget(
              //     label: S.of(context)!.temp_in,
              //     value: "31.0°C",
              //     iconData: Icons.arrow_upward),
              // SmallHomeWidget(
              //     label: S.of(context)!.temp_out,
              //     value: "37.5°C",
              //     iconData: Icons.arrow_downward),
              // SmallHomeWidget(
              //     label: S.of(context)!.pressure,
              //     value: "1.9bar",
              //     iconData: Icons.compare_arrows),
              // SmallHomeWidget(
              //     label: S.of(context)!.power_usage,
              //     value: "32%",
              //     iconData: Icons.timelapse),
              // SmallHomeWidget(
              //     label: S.of(context)!.pressure,
              //     value: "1.9bar",
              //     iconData: Icons.compare_arrows),
              // SmallHomeWidget(
              //     label: S.of(context)!.power_usage,
              //     value: "32%",
              //     iconData: Icons.timelapse),
              // SmallHomeWidget(
              //     label: S.of(context)!.pressure,
              //     value: "1.9bar",
              //     iconData: Icons.compare_arrows),
              // SmallHomeWidget(
              //     label: S.of(context)!.power_usage,
              //     value: "32%",
              //     iconData: Icons.timelapse),
              // ],
              ),
        ),
      ],
      // )
    );
  }
}
