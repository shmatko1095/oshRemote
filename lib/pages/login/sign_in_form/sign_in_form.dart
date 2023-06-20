import 'dart:async';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:osh_remote/block/sign_in/sign_in_bloc.dart';
import 'package:osh_remote/pages/password_recovery/password_recovery_page.dart';
import 'package:osh_remote/pages/user_confirmation/user_confirmation_page.dart';
import 'package:osh_remote/utils/constants.dart';
import 'package:osh_remote/utils/error_message_factory.dart';
import 'package:osh_remote/widgets/confirm_button.dart';
import 'package:osh_remote/widgets/password_field.dart';
import 'package:osh_remote/widgets/username_field.dart';

part 'parts/forgot_password_button.dart';

part 'parts/try_demo_button.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<StatefulWidget> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  late final StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();

    _subscription = context
        .read<SignInBloc>()
        .exceptionStream
        .listen((exception) => onBlockException(context, exception));
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  Future<void> _userNotConfirmedDialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context)!.user_not_confirmed_title),
          content: Text(S.of(context)!.user_not_confirmed_message),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: Text(S.of(context)!.doConfirmUser),
              onPressed: () => Navigator.of(context).pushAndRemoveUntil<void>(
                  UserConfirmationPage.route(), (route) => false),
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: Text(S.of(context)!.cancel),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void onBlockException(context, Exception exception) {
    if (exception.runtimeType == auth.UserNotConfirmedException) {
      _userNotConfirmedDialogBuilder(context);
    } else {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(ErrorMessageFactory.get(exception, context))),
        );
    }
  }

  PasswordField _getPasswordField(BuildContext context) {
    return PasswordField<SignInBloc, SignInState>(
      buildWhen: (previous, current) => previous.password != current.password,
      onChanged: (password) =>
          context.read<SignInBloc>().add(SignInPasswordChanged(password)),
      labelText: S.of(context)!.password,
      hintText: S.of(context)!.enterPassword,
      errorText: () => context.read<SignInBloc>().state.password.isValid() ||
              context.read<SignInBloc>().state.password.value.isEmpty
          ? null
          : S.of(context)!.passwordValidatorWarning,
    );
  }

  UsernameField _getUsernameField(BuildContext context) {
    return UsernameField<SignInBloc, SignInState>(
      buildWhen: (previous, current) => previous.email != current.email,
      onChanged: (username) =>
          context.read<SignInBloc>().add(SignInUsernameChanged(username)),
      errorText: () => context.read<SignInBloc>().state.email.isValid() ||
              context.read<SignInBloc>().state.email.value.isEmpty
          ? null
          : S.of(context)!.pleaseEnterYourEmail,
    );
  }

  ConfirmButton _getConfirmButton(BuildContext context) {
    return ConfirmButton<SignInBloc, SignInState>(
        text: Text(S.of(context)!.signIn),
        isInProgress: () => context.read<SignInBloc>().state.inProgress,
        onPressed: () {
          return context.read<SignInBloc>().isConfirmAvailable()
              ? () =>
                  context.read<SignInBloc>().add(const SignInLoginRequested())
              : null;
        });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: Constants.formPadding,
        child: Column(
          children: [
            ...[
              _getUsernameField(context),
              _getPasswordField(context),
              _getConfirmButton(context),
              const _ForgotPasswordButton(),
              const _TryDemoButton(),
            ].expand((element) => [element, const SizedBox(height: 24)])
          ],
        ));
  }
}
