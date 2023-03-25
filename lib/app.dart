import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:osh_remote/block/sign_in/sign_in_bloc.dart';
import 'package:osh_remote/pages/home/home.dart';
import 'package:osh_remote/pages/splash_page.dart';
import 'package:osh_remote/injection_container.dart';
import 'package:osh_remote/pages/login/login_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:osh_remote/utils/error_message_factory.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: getIt<AuthenticationRepository>(),
      child: BlocProvider(
        create: (_) => SignInBloc(getIt<AuthenticationRepository>()),
        child: const AppView(),
      ),
    );
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<SignInBloc>().exceptionStream
        .listen((exception) => onBlockException(context, exception));
  }

  void onBlockException(context, Exception exception) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(ErrorMessageFactory.get(exception, context))),
      );
  }

  @override
  Widget build(BuildContext context) {
    getIt<AuthenticationRepository>().configure().whenComplete(() => {
      context.read<SignInBloc>().add(const SignInFetchSessionRequested())
    });

    return MaterialApp(
      title: "OSH Remote",
      theme: ThemeData(brightness: Brightness.light),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.system,
      localizationsDelegates: S.localizationsDelegates,
      supportedLocales: S.supportedLocales,
      debugShowCheckedModeBanner: false,

      navigatorKey: _navigatorKey,
      builder: (context, child) {
        return BlocListener<SignInBloc, SignInState>(
          listener: (context, state) {
            if (state.inProgress) return;
            if (state.isSignedIn) {
              _navigator.pushAndRemoveUntil<void>(HomePage.route(), (route) => false);
            } else {
              _navigator.pushAndRemoveUntil<void>(LoginPage.route(), (route) => false);
            }
          },
          child: child,
        );
      },
      onGenerateRoute: (_) => SplashPage.route(),
    );
  }
}
