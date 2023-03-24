part of '../user_confirmation_page.dart';

class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.of(context).pushAndRemoveUntil<void>(LoginPage.route(), (route) => false),
      child: Text(S.of(context)!.backToSignIn),
    );
  }
}