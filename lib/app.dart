import 'package:authentication_repository/authentication_repository.dart';
import 'package:aws_iot_api/iot-2015-05-28.dart';
import 'package:aws_iot_repository/aws_iot_repository_factory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mqtt_client_repository/mqtt_client_repository_factory.dart';
import 'package:osh_remote/block/authentication/sign_up_bloc.dart';
import 'package:osh_remote/block/mqtt_client/mqtt_client_bloc.dart';
import 'package:osh_remote/block/sign_in/sign_in_bloc.dart';
import 'package:osh_remote/block/thing_cubit/thing_controller_cubit.dart';
import 'package:osh_remote/models/user.dart';
import 'package:osh_remote/pages/home/home.dart';
import 'package:osh_remote/pages/login/login_page.dart';
import 'package:osh_remote/pages/splash_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepo = AuthenticationRepository();

    return RepositoryProvider.value(
        value: authRepo,
        child: MultiBlocProvider(
          providers: [
            BlocProvider<MqttClientBloc>(
              create: (_) => MqttClientBloc(),
            ),
            BlocProvider<ThingControllerCubit>(
              create: (_) => ThingControllerCubit(),
            ),
            BlocProvider<SignInBloc>(
              create: (_) => SignInBloc(authRepo),
            ),
            BlocProvider<SignUpBloc>(
              create: (_) => SignUpBloc(authRepo),
            )
          ],
          child: const AppView(),
        ));
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  void _signInStatusListener(BuildContext context, SignInState state) {
    if (state.status == SignInStatus.authorized) {
      _initRepo();
      _navigator.pushAndRemoveUntil<void>(Home.route(), (route) => false);
    } else if (state.status == SignInStatus.demo) {
      _initRepoDemo();
      _navigator.pushAndRemoveUntil<void>(Home.route(), (route) => false);
    } else {
      _navigator.pushAndRemoveUntil<void>(LoginPage.route(), (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    RepositoryProvider.of<AuthenticationRepository>(context)
        .configure()
        .whenComplete(() => {
              context
                  .read<SignInBloc>()
                  .add(const SignInFetchUserDataRequested())
            });

    return BlocListener<SignInBloc, SignInState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: _signInStatusListener,
        child: MaterialApp(
          title: "OSH",
          theme: ThemeData(brightness: Brightness.light),
          darkTheme: ThemeData(brightness: Brightness.dark),
          themeMode: ThemeMode.system,
          localizationsDelegates: S.localizationsDelegates,
          supportedLocales: S.supportedLocales,
          debugShowCheckedModeBanner: false,
          navigatorKey: _navigatorKey,
          onGenerateRoute: (_) => SplashPage.route(),
        ));
  }

  void _initRepo() {
    const region = "us-east-1";
    const server = 'a3qrc8lpkkm4w-ats.iot.us-east-1.amazonaws.com';
    final cred = AwsClientCredentials(
        accessKey: "AKIAVO57NB3Y6D3TOTRF",
        secretKey: "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");

    final mqttRepo = MqttRepositoryFactory.createInstance(server: server);
    final iotRepo = AwsIotRepositoryFactory.createInstance(
        region: region, credentials: cred);

    context.read<MqttClientBloc>().setRepo(mqttRepo, iotRepo);
    context.read<ThingControllerCubit>().setRepo(mqttRepo);
  }

  void _initRepoDemo() {
    final user = User(userId: "demo", email: "demo@mail.com", name: "username");
    context.read<SignInBloc>().state.user = user;

    final mqttRepo = MqttRepositoryFactory.createInstance(demo: true);
    final iotRepo = AwsIotRepositoryFactory.createInstance(demo: true);

    context.read<MqttClientBloc>().setRepo(mqttRepo, iotRepo);
    context.read<ThingControllerCubit>().setRepo(mqttRepo);
  }
}
