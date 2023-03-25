part of '../sign_in_form.dart';

class _TryDemoButton extends StatelessWidget {
  const _TryDemoButton();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.of(context)
          .pushAndRemoveUntil(HomePage.route(), (route) => false),
      child: Text(S.of(context)!.tryDemo),
    );
  }
}
