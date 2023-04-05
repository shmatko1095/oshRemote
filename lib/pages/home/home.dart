import 'package:aws_iot_api/iot-2015-05-28.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mqtt_repository/mqtt_repository.dart';
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
    const region = "us-east-1";
    const server = 'a3qrc8lpkkm4w-ats.iot.us-east-1.amazonaws.com';
    final cred = AwsClientCredentials(
        accessKey: "AKIAVO57NB3Y6D3TOTRF",
        secretKey: "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");
    final mqttRepository = MqttServerClientRepository(region, cred, server);
    final bloc = MqttClientBloc(repository: mqttRepository);

    context.read<SignInBloc>().add(const SignInFetchUserRequested());

    onSignInEvent(BuildContext context, SignInState state) {
      final thingNameByUserId = state.user.userId;
      bloc.add(MqttConnectRequested(thingId: thingNameByUserId));
    }

    return BlocProvider<MqttClientBloc>(
        create: (_) => bloc,
        child: SafeArea(
            child: BlocListener<SignInBloc, SignInState>(
                listenWhen: (previous, current) =>
                    previous.user != current.user,
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
                ))));
  }
}
