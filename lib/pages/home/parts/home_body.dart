import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:osh_remote/pages/home/parts/home_temp_indicator.dart';
import 'package:osh_remote/pages/home/parts/selector_mode_widget.dart';
import 'package:osh_remote/pages/home/parts/small_widget.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  late ScrollController _scrollController;
  static const kExpandedHeight = 300.0;
  Widget? _title;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()..addListener(() {
      setState(() {
        _title = _isSliverAppBarExpanded ? const Text("Title") : null;
      });
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
        SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 120.0, //height
          ),
          delegate: SliverChildListDelegate(
            [
              SmallHomeWidget(
                  label: S.of(context)!.heater_status,
                  value: "1/6",
                  iconData: Icons.local_fire_department),
              SmallHomeWidget(
                  label: S.of(context)!.pump_status,
                  value: "46%",
                  iconData: Icons.loop),
              SmallHomeWidget(
                  label: S.of(context)!.temp_in,
                  value: "31.0°C",
                  iconData: Icons.arrow_upward),
              SmallHomeWidget(
                  label: S.of(context)!.temp_out,
                  value: "37.5°C",
                  iconData: Icons.arrow_downward),
              SmallHomeWidget(
                  label: S.of(context)!.pressure,
                  value: "1.9bar",
                  iconData: Icons.compare_arrows),
              SmallHomeWidget(
                  label: S.of(context)!.power_usage,
                  value: "32%",
                  iconData: Icons.timelapse),
              SmallHomeWidget(
                  label: S.of(context)!.pressure,
                  value: "1.9bar",
                  iconData: Icons.compare_arrows),
              SmallHomeWidget(
                  label: S.of(context)!.power_usage,
                  value: "32%",
                  iconData: Icons.timelapse),
              SmallHomeWidget(
                  label: S.of(context)!.pressure,
                  value: "1.9bar",
                  iconData: Icons.compare_arrows),
              SmallHomeWidget(
                  label: S.of(context)!.power_usage,
                  value: "32%",
                  iconData: Icons.timelapse),
              SmallHomeWidget(
                  label: S.of(context)!.pressure,
                  value: "1.9bar",
                  iconData: Icons.compare_arrows),
              SmallHomeWidget(
                  label: S.of(context)!.power_usage,
                  value: "32%",
                  iconData: Icons.timelapse),
              SmallHomeWidget(
                  label: S.of(context)!.pressure,
                  value: "1.9bar",
                  iconData: Icons.compare_arrows),
              SmallHomeWidget(
                  label: S.of(context)!.power_usage,
                  value: "32%",
                  iconData: Icons.timelapse),
            ],
          ),
        ),
      ],
      // )
    );
  }
}
