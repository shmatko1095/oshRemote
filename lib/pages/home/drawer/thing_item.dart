import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:osh_remote/block/mqtt_client/mqtt_client_bloc.dart';
import 'package:osh_remote/block/thing_cubit/thing_controller_cubit.dart';
import 'package:osh_remote/block/thing_cubit/thing_controller_state.dart';
import 'package:osh_remote/pages/home/drawer/rename_thing_dialog.dart';

class ThingItem extends StatelessWidget {
  static const _closeDelay = Duration(milliseconds: 1000);

  final String sn;

  const ThingItem({required this.sn, super.key});

  Widget? _getTrailing(ThingConnectionStatus status) {
    if (status == ThingConnectionStatus.connecting) {
      return const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 3.0));
    } else if (status == ThingConnectionStatus.connected) {
      return const Icon(Icons.check_circle_outline, color: Colors.green);
    } else {
      return const Icon(Icons.close);
      // return Container();
    }
  }

  void _onDeviceTap(BuildContext context, String sn) {
    context.read<ThingControllerCubit>().disconnectConnectedThings();
    context.read<ThingControllerCubit>().connect(sn: sn);
  }

  void _onDeviceRename(BuildContext context, String sn) {
    RenameThingDialog.show(
        context,
        (name) =>
            context.read<ThingControllerCubit>().rename(sn: sn, name: name));
  }

  void _onDeviceRemove(BuildContext context, String sn) {
    context.read<ThingControllerCubit>().disconnect(sn: sn);
    context.read<MqttClientBloc>().add(MqttRemoveDeviceEvent(sn: sn));
  }

  void _onConnectionChanged(BuildContext context, ThingControllerState state) {
    if (state.getThingData(sn)!.status == ThingConnectionStatus.connected) {
      Future.delayed(_closeDelay, () => Scaffold.of(context).openEndDrawer());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key("thing_item_$sn"),
      onDismissed: (dir) => _onDeviceRemove(context, sn),
      direction: DismissDirection.startToEnd,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerLeft,
        child: const Icon(Icons.delete),
      ),
      child: BlocBuilder<ThingControllerCubit, ThingControllerState>(
        buildWhen: (previous, current) =>
            previous.getThingData(sn) != current.getThingData(sn),
        builder: (context, state) => ListTile(
            leading: const Icon(Icons.home),
            title: Text(state.getThingData(sn)!.name),
            onTap: () => _onDeviceTap(context, sn),
            onLongPress: () => _onDeviceRename(context, sn),
            trailing: BlocListener<ThingControllerCubit, ThingControllerState>(
              listener: _onConnectionChanged,
              child: _getTrailing(state.getThingData(sn)!.status),
            )),
      ),
    );
  }
}
