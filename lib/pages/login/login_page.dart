import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:osh_remote/block/authentication/sign_up_bloc.dart';
import 'package:osh_remote/block/sign_in/sign_in_bloc.dart';
import 'package:osh_remote/injection_container.dart';
import 'package:osh_remote/pages/login/sign_in_form/sign_in_form.dart';
import 'package:osh_remote/pages/login/sign_up_form/sign_up_form.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const LoginPage());
  }

  @override
  State createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _tabList = <Widget>[SignIn(), SignUp()];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Color _getTabLabelColor(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? Colors.white : Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: TabBar(
          controller: _tabController,
          labelColor: _getTabLabelColor(context),
          indicatorColor: Theme.of(context).primaryColor,
          tabs: <Tab>[
            Tab(text: S.of(context)!.signIn),
            Tab(text: S.of(context)!.signUp),
          ],
        ),
        body: TabBarView(
          controller: _tabController,
          children: _tabList,
        ),
      ),
    );
  }
}

class SignIn extends StatelessWidget {
  final _bloc = SignInBloc(getIt<AuthenticationRepository>());

  SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _bloc,
      child: const SignInForm(),
    );
  }
}

class SignUp extends StatelessWidget {
  final _bloc = SignUpBloc(getIt<AuthenticationRepository>());

  SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _bloc,
      child: const SignUpForm(),
    );
  }
}
