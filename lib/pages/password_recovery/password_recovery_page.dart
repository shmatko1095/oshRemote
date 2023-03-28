import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:osh_remote/block/authentication/authentication_base_bloc.dart';
import 'package:osh_remote/block/authentication/password_recovery_bloc.dart';
import 'package:osh_remote/pages/login/login_page.dart';
import 'package:osh_remote/utils/error_message_factory.dart';
import 'package:osh_remote/widgets/confirm_button.dart';
import 'package:osh_remote/widgets/confirm_code_field.dart';
import 'package:osh_remote/widgets/password_field.dart';
import 'package:osh_remote/widgets/username_field.dart';
import 'package:osh_remote/widgets/utils.dart';

part 'parts/back_button.dart';
part 'parts/title.dart';

class PasswordRecoveryPage extends StatelessWidget {
  const PasswordRecoveryPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(
        builder: (_) => const PasswordRecoveryPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PasswordRecoveryBloc(
          authenticationRepository:
              RepositoryProvider.of<AuthenticationRepository>(context)),
      child: const PasswordRecoveryForm(),
    );
  }
}

class PasswordRecoveryForm extends StatefulWidget {
  const PasswordRecoveryForm({super.key});

  @override
  State<StatefulWidget> createState() => _PasswordRecoveryFormState();
}

class _PasswordRecoveryFormState extends State<PasswordRecoveryForm> {
  final List _widgets = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _widgets.add(const _Title());
    _widgets.add(_getUsernameField(context));
    _widgets.add(_getPassword0Field(context));
    _widgets.add(_getPassword1Field(context));
    _widgets.add(_getConfirmButton(context));
    _widgets.add(const _BackButton());

    context
        .read<PasswordRecoveryBloc>()
        .exceptionStream
        .listen((exception) => onBlockException(context, exception));
  }

  UsernameField _getUsernameField(BuildContext context) {
    return UsernameField<PasswordRecoveryBloc, AuthenticationState>(
      buildWhen: (previous, current) => previous.email != current.email,
      onChanged: (username) => context
          .read<PasswordRecoveryBloc>()
          .add(AuthenticationUsernameChanged(username)),
      errorText: () =>
          context.read<PasswordRecoveryBloc>().state.email.isValid() ||
                  context.read<PasswordRecoveryBloc>().state.email.value.isEmpty
              ? null
              : S.of(context)!.pleaseEnterYourEmail,
    );
  }

  PasswordField _getPassword0Field(BuildContext context) {
    return PasswordField<PasswordRecoveryBloc, AuthenticationState>(
      buildWhen: (previous, current) => previous.password0 != current.password0,
      onChanged: (password) => context
          .read<PasswordRecoveryBloc>()
          .add(AuthenticationPassword0Changed(password)),
      labelText: S.of(context)!.password,
      hintText: S.of(context)!.enterPassword,
      errorText: () => context
                  .read<PasswordRecoveryBloc>()
                  .state
                  .password0
                  .isValid() ||
              context.read<PasswordRecoveryBloc>().state.password0.value.isEmpty
          ? null
          : S.of(context)!.passwordValidatorWarning,
    );
  }

  PasswordField _getPassword1Field(BuildContext context) {
    return PasswordField<PasswordRecoveryBloc, AuthenticationState>(
      buildWhen: (previous, current) => previous != current,
      onChanged: (password) => context
          .read<PasswordRecoveryBloc>()
          .add(AuthenticationPassword1Changed(password)),
      labelText: S.of(context)!.confirmPassword,
      hintText: S.of(context)!.reEnterPassword,
      errorText: () =>
          context.read<PasswordRecoveryBloc>().state.password1.value.isEmpty ||
                  context.read<PasswordRecoveryBloc>().state.password1.value ==
                      context.read<PasswordRecoveryBloc>().state.password0.value
              ? null
              : S.of(context)!.duplicatePasswordValidatorMag,
    );
  }

  ConfirmButton _getConfirmButton(BuildContext context) {
    return ConfirmButton<PasswordRecoveryBloc, AuthenticationState>(
        text: Text(S.of(context)!.confirm),
        isInProgress: () =>
            context.read<PasswordRecoveryBloc>().state.inProgress,
        onPressed: () {
          return context.read<PasswordRecoveryBloc>().isConfirmAvailable()
              ? () => context
                  .read<PasswordRecoveryBloc>()
                  .add(const AuthenticationConfirmEvent())
              : null;
        });
  }

  ConfirmCodeField _getConfirmCodeInput(BuildContext context) {
    return ConfirmCodeField<PasswordRecoveryBloc, AuthenticationState>(
        buildWhen: (previous, current) =>
            previous.confirmCode != current.confirmCode,
        onChanged: (code) => context
            .read<PasswordRecoveryBloc>()
            .add(AuthenticationConfirmCodeChanged(code)),
        resendCode: () => context
            .read<PasswordRecoveryBloc>()
            .add(const AuthenticationResendCodeRequested()),
        errorText: () => context
                    .read<PasswordRecoveryBloc>()
                    .state
                    .confirmCode
                    .value
                    .isEmpty ||
                context.read<PasswordRecoveryBloc>().state.confirmCode.isValid()
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
    return BlocListener<PasswordRecoveryBloc, AuthenticationState>(
        listenWhen: (previous, current) => previous.step != current.step,
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
