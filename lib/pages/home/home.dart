import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:osh_remote/block/mqtt_client/mqtt_client_bloc.dart';
import 'package:osh_remote/block/sign_in/sign_in_bloc.dart';
import 'package:osh_remote/block/thing_cubit/thing_controller_cubit.dart';
import 'package:osh_remote/block/thing_cubit/thing_controller_state.dart';
import 'package:osh_remote/pages/home/parts/home_body.dart';
import 'package:osh_remote/pages/splash_page.dart';
import 'package:osh_remote/utils/error_message_factory.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const Home());
  }

  void _onBlocException(BuildContext context, Exception exception) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(ErrorMessageFactory.get(exception, context))),
      );
  }

  void _initExceptionListener(BuildContext context) {
    context
        .read<MqttClientBloc>()
        .exceptionStream
        .listen((event) => _onBlocException(context, event));

    context
        .read<ThingControllerCubit>()
        .exceptionStream
        .listen((event) => _onBlocException(context, event));
  }

  void _onMqttClientConnected(BuildContext context, MqttClientState state) {
    context.read<ThingControllerCubit>().init(clientId: state.clientName);

    String userId = context.read<SignInBloc>().state.user.userId;
    context.read<MqttClientBloc>().add(MqttGetUserThings(userId: userId));
  }

  void _onThingListUpdate(BuildContext context, ThingControllerState state) {
    if (state.connectedThing == null && state.thingDataMap.isNotEmpty) {
      final firstSn = state.thingDataMap.values.first.sn;
      final lastSn = context.read<ThingControllerCubit>().lastConnectedThing;
      context.read<ThingControllerCubit>().connect(sn: lastSn ?? firstSn);
    }
  }

  Widget _buildHomePage(BuildContext context, MqttClientState state) {
    final list = context.read<MqttClientBloc>().state.userThingsList;
    context.read<ThingControllerCubit>().updateThingList(snList: list);

    return BlocListener<MqttClientBloc, MqttClientState>(
      listenWhen: (previous, current) =>
          previous.userThingsList != current.userThingsList,
      listener: (context, state) => context
          .read<ThingControllerCubit>()
          .updateThingList(snList: state.userThingsList),
      child: BlocListener<ThingControllerCubit, ThingControllerState>(
        listenWhen: (previous, current) =>
            previous.thingDataMap.length != current.thingDataMap.length,
        listener: _onThingListUpdate,
        child: const HomePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _initExceptionListener(context);

    final userId = context.read<SignInBloc>().state.user.userId;
    context.read<MqttClientBloc>().add(MqttStartEvent(userId: userId));

    return BlocListener<MqttClientBloc, MqttClientState>(
      listenWhen: (previous, current) =>
          previous.connectionState != current.connectionState &&
          current.connectionState == MqttClientConnectionStatus.connected,
      listener: _onMqttClientConnected,
      child: BlocBuilder<MqttClientBloc, MqttClientState>(
        buildWhen: (previous, current) =>
            previous.connectionState != current.connectionState,
        builder: (context, state) {
          return state.connectionState == MqttClientConnectionStatus.connected
              ? _buildHomePage(context, state)
              : const SplashPage();
        },
      ),
    );
  }
}
