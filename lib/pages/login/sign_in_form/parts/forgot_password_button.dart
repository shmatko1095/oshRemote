part of '../sign_in_form.dart';

class _ForgotPasswordButton extends StatelessWidget {
  const _ForgotPasswordButton();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.of(context)
          .pushAndRemoveUntil(PasswordRecoveryPage.route(), (route) => false),
      child: Text(S.of(context)!.forgotYourPassword),
    );
  }
}
