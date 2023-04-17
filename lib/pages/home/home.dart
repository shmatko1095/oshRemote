import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:osh_remote/block/mqtt_client/mqtt_client_bloc.dart';
import 'package:osh_remote/block/sign_in/sign_in_bloc.dart';
import 'package:osh_remote/pages/home/parts/home_body.dart';
import 'package:osh_remote/pages/home/widget/drawer/drawer_presenter.dart';
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

  void _onDeviceTap(BuildContext context, String device) {
    print("Selected device: $device");
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
        onDeviceTap: (device) => _onDeviceTap(context, device));

    return Scaffold(
      drawer: drawer,
      body: const HomePage(),
    );
  }
}
