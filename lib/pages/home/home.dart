import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:osh_remote/block/mqtt_client/mqtt_client_bloc.dart';
import 'package:osh_remote/block/sign_in/sign_in_bloc.dart';
import 'package:osh_remote/pages/home/drawer/drawer.dart';
import 'package:osh_remote/pages/home/drawer/rename_thing_dealog.dart';
import 'package:osh_remote/pages/home/parts/home_body.dart';
import 'package:osh_remote/utils/error_message_factory.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const Home());
  }

  void _onSignOut(BuildContext context) {
    context.read<SignInBloc>().add(const SignInLogoutRequested());
    context.read<MqttClientBloc>().add(const MqttStopRequestedEvent());
  }

  void _onDeviceRemove(BuildContext context, String sn) {
    context.read<MqttClientBloc>().add(MqttRemoveDeviceRequestedEvent(sn: sn));
  }

  void _onDeviceRename(BuildContext context, String sn) {
    RenameThingDialog.show(
        context,
        (name) => context
            .read<MqttClientBloc>()
            .add(MqttRenameDeviceRequestedEvent(sn: sn, name: name)));
  }

  void _onDeviceTap(BuildContext context, String sn) {
    print("_onDeviceTap: $sn");
  }

  void _onBlocException(BuildContext context, Exception exception) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(ErrorMessageFactory.get(exception, context))),
      );
  }

  @override
  Widget build(BuildContext context) {
    context
        .read<MqttClientBloc>()
        .exceptionStream
        .listen((event) => _onBlocException(context, event));

    final userId = context.read<SignInBloc>().state.user.userId;
    context.read<MqttClientBloc>().add(MqttStartRequestedEvent(userId: userId));

    final drawer = DrawerPresenter(
      onSignOut: () => _onSignOut(context),
      onTap: (device) => _onDeviceTap(context, device),
      onRemove: (device) => _onDeviceRemove(context, device),
      onRename: (device) => _onDeviceRename(context, device),
    );

    return Scaffold(
      drawer: drawer,
      body: const HomePage(),
    );
  }
}
