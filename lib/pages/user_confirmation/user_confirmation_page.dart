import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:osh_remote/block/authentication/authentication_base_bloc.dart';
import 'package:osh_remote/block/authentication/user_confirmation_bloc.dart';
import 'package:osh_remote/injection_container.dart';
import 'package:osh_remote/pages/login/login_page.dart';
import 'package:osh_remote/utils/error_message_factory.dart';
import 'package:osh_remote/widgets/confirm_button.dart';
import 'package:osh_remote/widgets/confirm_code_field.dart';
import 'package:osh_remote/widgets/username_field.dart';
import 'package:osh_remote/widgets/utils.dart';

part 'parts/back_button.dart';
part 'parts/title.dart';

class UserConfirmationPage extends StatelessWidget {
  const UserConfirmationPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(
        builder: (_) => const UserConfirmationPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserConfirmationBloc(
          authenticationRepository: getIt<AuthenticationRepository>()),
      child: const UserConfirmationForm(),
    );
  }
}

class UserConfirmationForm extends StatefulWidget {
  const UserConfirmationForm({super.key});

  @override
  State<StatefulWidget> createState() => _UserConfirmationFormState();
}

class _UserConfirmationFormState extends State<UserConfirmationForm> {
  final List _widgets = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _widgets.add(const _Title());
    _widgets.add(_getUsernameField(context));
    _widgets.add(_getConfirmButton(context));
    _widgets.add(const _BackButton());

    context
        .read<UserConfirmationBloc>()
        .exceptionStream
        .listen((exception) => onBlockException(context, exception));
  }

  UsernameField _getUsernameField(BuildContext context) {
    return UsernameField<UserConfirmationBloc, AuthenticationState>(
      buildWhen: (previous, current) => previous.email != current.email,
      onChanged: (username) => context
          .read<UserConfirmationBloc>()
          .add(AuthenticationUsernameChanged(username)),
      errorText: () =>
          context.read<UserConfirmationBloc>().state.email.isValid() ||
                  context.read<UserConfirmationBloc>().state.email.value.isEmpty
              ? null
              : S.of(context)!.pleaseEnterYourEmail,
    );
  }

  ConfirmButton _getConfirmButton(BuildContext context) {
    return ConfirmButton<UserConfirmationBloc, AuthenticationState>(
        text: Text(S.of(context)!.confirm),
        isInProgress: () =>
            context.read<UserConfirmationBloc>().state.inProgress,
        onPressed: () {
          return context.read<UserConfirmationBloc>().isConfirmAvailable()
              ? () => context
                  .read<UserConfirmationBloc>()
                  .add(const AuthenticationConfirmEvent())
              : null;
        });
  }

  ConfirmCodeField _getConfirmCodeInput(BuildContext context) {
    return ConfirmCodeField<UserConfirmationBloc, AuthenticationState>(
        buildWhen: (previous, current) =>
            previous.confirmCode != current.confirmCode,
        onChanged: (code) => context
            .read<UserConfirmationBloc>()
            .add(AuthenticationConfirmCodeChanged(code)),
        resendCode: () => context
            .read<UserConfirmationBloc>()
            .add(const AuthenticationResendCodeRequested()),
        errorText: () => context
                    .read<UserConfirmationBloc>()
                    .state
                    .confirmCode
                    .value
                    .isEmpty ||
                context.read<UserConfirmationBloc>().state.confirmCode.isValid()
            ? null
            : S.of(context)!.confirmationCodeValidatorWarning);
  }

  void onBlockEvent(context, AuthenticationState state) {
    if (state.step == AuthenticationStep.step1Done) {
      setState(() {
        int len = _widgets.length;
        _widgets.insert(len - 2, _getConfirmCodeInput(context));
      });
    } else if (state.step == AuthenticationStep.success) {
      Navigator.of(context)
          .pushAndRemoveUntil(LoginPage.route(), (route) => false);
    }
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
    return BlocListener<UserConfirmationBloc, AuthenticationState>(
        listener: (context, state) => onBlockEvent(context, state),
        child: SafeArea(
            child: Scaffold(
                body: SingleChildScrollView(
          padding: padding,
          child: Column(
            children: [
              ..._widgets
                  .expand((widget) => [widget, const SizedBox(height: 24)])
            ],
          ),
        ))));
  }
}
