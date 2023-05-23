import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:osh_remote/block/thing_cubit/model/thing_calendar.dart';
import 'package:osh_remote/block/thing_cubit/thing_controller_cubit.dart';
import 'package:osh_remote/block/thing_cubit/thing_controller_state.dart';

class SelectorModeWidget extends StatefulWidget {
  const SelectorModeWidget({super.key});

  @override
  State<SelectorModeWidget> createState() => _SelectorModeWidgetState();
}

class _SelectorModeWidgetState extends State<SelectorModeWidget> {
  final List<BottomNavigationBarItem> _icons = [];

  ThingCalendar get _val =>
      context.read<ThingControllerCubit>().state.connectedThing!.calendar!;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _icons.add(BottomNavigationBarItem(
        label: S.of(context)!.off,
        icon: const Icon(Icons.power_settings_new),
        activeIcon: const Icon(Icons.power_settings_new, color: Colors.red)));
    _icons.add(BottomNavigationBarItem(
        label: S.of(context)!.antifreeze, icon: const Icon(Icons.ac_unit)));
    _icons.add(BottomNavigationBarItem(
        label: S.of(context)!.manual, icon: const Icon(Icons.back_hand)));
    _icons.add(BottomNavigationBarItem(
        label: S.of(context)!.daily, icon: const Icon(Icons.schedule)));
    _icons.add(BottomNavigationBarItem(
        label: S.of(context)!.weekly, icon: const Icon(Icons.calendar_month)));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ThingControllerCubit, ThingControllerState>(
        listenWhen: (previous, current) =>
            previous.connectedThing?.calendar! !=
            current.connectedThing?.calendar!,
        listener: (context, state) => setState(() {}),
        child: BottomNavigationBar(
          currentIndex: _val.currentMode.index,
          onTap: (i) => setState(() {
            _val.currentMode = CalendarMode.values[i];
            context.read<ThingControllerCubit>().pushMode();
          }),
          items: _icons,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
        ));
  }
}
