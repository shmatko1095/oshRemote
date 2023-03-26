import 'package:authentication_repository/authentication_repository.dart';
import 'package:aws_iot_api/iot-2015-05-28.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mqtt_repository/mqtt_repository.dart';
import 'package:osh_remote/block/mqtt_client/mqtt_client_bloc.dart';
import 'package:osh_remote/block/sign_in/sign_in_bloc.dart';
import 'package:osh_remote/injection_container.dart';
import 'package:osh_remote/pages/home/parts/home_body.dart';
import 'package:osh_remote/pages/login/login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const HomePage());
  }

  @override
  Widget build(BuildContext context) {
    const region = "us-east-1";
    const server = 'a3qrc8lpkkm4w-ats.iot.us-east-1.amazonaws.com';
    final credentials = AwsClientCredentials(
        accessKey: "AKIAVO57NB3Y6D3TOTRF",
        secretKey: "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");
    final mqttRepository =
        MqttServerClientRepository(region, credentials, server);

    return
      // RepositoryProvider.value(
      //   value: mqttRepository,
      //   child:
    MultiBlocProvider(
          providers: [
            BlocProvider<SignInBloc>(
              create: (_) => SignInBloc(getIt<AuthenticationRepository>()),
            ),
            BlocProvider<MqttClientBloc>(
              create: (_) => MqttClientBloc(repository: mqttRepository),
            ),
          ],
          child: const HomePageContent(),
        // )
    );
  }
}

class HomePageContent extends StatefulWidget {
  const HomePageContent({super.key});

  @override
  State createState() {
    return _HomePageContentState();
  }
}

class _HomePageContentState extends State<HomePageContent> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context
        .read<MqttClientBloc>()
        .add(const MqttClientConnectRequested(thingName: "oshRemote"));
  }

  void signOutCurrentUser() {
    context.read<SignInBloc>().add(const SignInLogoutRequested());
    Navigator.of(context)
        .pushAndRemoveUntil<void>(LoginPage.route(), (route) => false);
  }

  Widget _buildDrawerHeader() {
    return const UserAccountsDrawerHeader(
      accountName: Text('User Name'),
      accountEmail: Text('user.name@email.com'),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Colors.white,
        child: FlutterLogo(size: 42.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: const HomeBody(),
            drawer: Drawer(
                child: Column(
              children: <Widget>[
                _buildDrawerHeader(),
                Builder(
                  builder: (context) {
                    final userId = context
                        .select((SignInBloc bloc) => bloc.state.email.value);
                    return Text('UserID: $userId');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Device 1'),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Device 2'),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  leading: const Icon(Icons.add),
                  title: Text(S.of(context)!.addDevice),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: Text(S.of(context)!.settings),
                  onTap: () => Navigator.pop(context),
                ),
                const Spacer(),
                const Divider(thickness: 1.5),
                ListTile(
                  leading:
                      const Icon(Icons.power_settings_new, color: Colors.red),
                  title: Text(S.of(context)!.signOut),
                  onTap: signOutCurrentUser,
                ),
              ],
            ))));
  }
}
