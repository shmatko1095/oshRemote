part of '../sign_in_form.dart';

class _TryDemoButton extends StatelessWidget {
  const _TryDemoButton();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => context.read<SignInBloc>().add(const SignInDemo()),
      child: Text(S.of(context)!.tryDemo),
    );
  }
}
