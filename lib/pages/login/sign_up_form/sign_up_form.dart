import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:osh_remote/block/authentication/authentication_base_bloc.dart';
import 'package:osh_remote/block/authentication/sign_up_bloc.dart';
import 'package:osh_remote/pages/login/login_page.dart';
import 'package:osh_remote/utils/constants.dart';
import 'package:osh_remote/utils/error_message_factory.dart';
import 'package:osh_remote/widgets/confirm_button.dart';
import 'package:osh_remote/widgets/confirm_code_field.dart';
import 'package:osh_remote/widgets/password_field.dart';
import 'package:osh_remote/widgets/username_field.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<StatefulWidget> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final List _widgets = [];
  late final StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();

    _subscription = context
        .read<SignUpBloc>()
        .exceptionStream
        .listen((exception) => onBlockException(context, exception));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _widgets.add(_getNameField(context));
    _widgets.add(_getUsernameField(context));
    _widgets.add(_getPassword0Field(context));
    _widgets.add(_getPassword1Field(context));
    _widgets.add(_getConfirmButton(context));
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    _subscription.cancel();
  }

  UsernameField _getUsernameField(BuildContext context) {
    return UsernameField<SignUpBloc, AuthenticationState>(
      buildWhen: (previous, current) => previous.email != current.email,
      onChanged: (username) => context
          .read<SignUpBloc>()
          .add(AuthenticationUsernameChanged(username)),
      errorText: () => context.read<SignUpBloc>().state.email.isValid() ||
              context.read<SignUpBloc>().state.email.value.isEmpty
          ? null
          : S.of(context)!.pleaseEnterYourEmail,
    );
  }

  Widget _getNameField(BuildContext context) {
    return BlocBuilder<SignUpBloc, AuthenticationState>(
      buildWhen: (previous, current) => previous.name != current.name,
      builder: (context, state) {
        return TextField(
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: S.of(context)!.name,
            hintText: S.of(context)!.enterName,
          ),
          onChanged: (name) =>
              context.read<SignUpBloc>().add(AuthenticationNameChanged(name)),
        );
      },
    );
  }

  PasswordField _getPassword0Field(BuildContext context) {
    return PasswordField<SignUpBloc, AuthenticationState>(
      buildWhen: (previous, current) => previous.password0 != current.password0,
      onChanged: (password) => context
          .read<SignUpBloc>()
          .add(AuthenticationPassword0Changed(password)),
      labelText: S.of(context)!.password,
      hintText: S.of(context)!.enterPassword,
      errorText: () => context.read<SignUpBloc>().state.password0.isValid() ||
              context.read<SignUpBloc>().state.password0.value.isEmpty
          ? null
          : S.of(context)!.passwordValidatorWarning,
    );
  }

  PasswordField _getPassword1Field(BuildContext context) {
    return PasswordField<SignUpBloc, AuthenticationState>(
      buildWhen: (previous, current) => previous != current,
      onChanged: (password) => context
          .read<SignUpBloc>()
          .add(AuthenticationPassword1Changed(password)),
      labelText: S.of(context)!.confirmPassword,
      hintText: S.of(context)!.reEnterPassword,
      errorText: () =>
          context.read<SignUpBloc>().state.password1.value.isEmpty ||
                  context.read<SignUpBloc>().state.password1.value ==
                      context.read<SignUpBloc>().state.password0.value
              ? null
              : S.of(context)!.duplicatePasswordValidatorMag,
    );
  }

  ConfirmButton _getConfirmButton(BuildContext context) {
    return ConfirmButton<SignUpBloc, AuthenticationState>(
        text: Text(S.of(context)!.confirm),
        isInProgress: () => context.read<SignUpBloc>().state.inProgress,
        onPressed: () {
          return context.read<SignUpBloc>().isConfirmAvailable()
              ? () => context
                  .read<SignUpBloc>()
                  .add(const AuthenticationConfirmEvent())
              : null;
        });
  }

  ConfirmCodeField _getConfirmCodeInput(BuildContext context) {
    return ConfirmCodeField<SignUpBloc, AuthenticationState>(
        buildWhen: (previous, current) =>
            previous.confirmCode != current.confirmCode,
        onChanged: (code) => context
            .read<SignUpBloc>()
            .add(AuthenticationConfirmCodeChanged(code)),
        resendCode: () => context
            .read<SignUpBloc>()
            .add(const AuthenticationResendCodeRequested()),
        errorText: () =>
            context.read<SignUpBloc>().state.confirmCode.value.isEmpty ||
                    context.read<SignUpBloc>().state.confirmCode.isValid()
                ? null
                : S.of(context)!.confirmationCodeValidatorWarning);
  }

  void onBlockEvent(context, AuthenticationState state) {
    if (state.step == AuthenticationStep.step1Done) {
      setState(() {
        int len = _widgets.length;
        _widgets.insert(len - 1, _getConfirmCodeInput(context));
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
    return BlocListener<SignUpBloc, AuthenticationState>(
        listenWhen: (previous, current) => previous.step != current.step,
        listener: (context, state) => onBlockEvent(context, state),
        child: SafeArea(
            child: Scaffold(
                body: SingleChildScrollView(
          padding: Constants.formPadding,
          child: Column(
            children: [
              ..._widgets
                  .expand((widget) => [widget, const SizedBox(height: 24)])
            ],
          ),
        ))));
  }
}
