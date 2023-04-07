import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:osh_remote/block/mqtt_client/mqtt_client_bloc.dart';
import 'package:osh_remote/block/sign_in/sign_in_bloc.dart';
import 'package:osh_remote/pages/home/parts/home_body.dart';
import 'package:osh_remote/pages/splash_page.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const Home());
  }

  @override
  Widget build(BuildContext context) {
    context.read<SignInBloc>().add(const SignInFetchUserRequested());

    onSignInEvent(BuildContext context, SignInState state) {
      final userId = state.user.userId;
      BlocProvider.of<MqttClientBloc>(context)
          .add(MqttCreateThingGroupRequestedEvent(groupName: userId));
      BlocProvider.of<MqttClientBloc>(context)
          .add(MqttConnectRequested(thingId: "${userId}_client"));
    }

    return SafeArea(
        child: BlocListener<SignInBloc, SignInState>(
            listenWhen: (previous, current) => previous.user != current.user,
            listener: (context, state) => onSignInEvent(context, state),
            child: BlocBuilder<MqttClientBloc, MqttClientState>(
              buildWhen: (previous, current) =>
                  previous.connectionState != current.connectionState,
              builder: (context, state) {
                if (state.connectionState ==
                    MqttClientConnectionStatus.connected) {
                  return const HomePage();
                } else {
                  return const SplashPage();
                }
              },
            )));
  }
}
