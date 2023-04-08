import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:osh_remote/block/sign_in/sign_in_bloc.dart';
import 'package:osh_remote/pages/home/parts/home_body.dart';
import 'package:osh_remote/pages/home/widget/drawer/drawer_presenter.dart';
import 'package:osh_remote/pages/login/login_page.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const Home());
  }

  void _onSignOut(BuildContext context) {
    context.read<SignInBloc>().add(const SignInLogoutRequested());
    Navigator.of(context)
        .pushAndRemoveUntil<void>(LoginPage.route(), (route) => false);
  }

  void _onDeviceTap(BuildContext context, String device) {
    print("Selected device: $device");
  }

  @override
  Widget build(BuildContext context) {
    context.read<SignInBloc>().add(const SignInFetchUserDataRequested());

    final drawer = DrawerPresenter(
        onSignOut: () => _onSignOut(context),
        onDeviceTap: (device) => _onDeviceTap(context, device));

    return Scaffold(
      drawer: drawer,
      body: const HomePage(),
    );
  }
}
