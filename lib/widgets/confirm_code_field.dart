import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConfirmCodeField<Bloc extends StateStreamable<State>, State>
    extends StatelessWidget {
  final _controller = TextEditingController();
  final BlocBuilderCondition? buildWhen;
  final ValueChanged<String>? onChanged;
  final Function() resendCode;
  final String? Function() errorText;

  ConfirmCodeField(
      {this.buildWhen,
      this.onChanged,
      required this.resendCode,
      required this.errorText,
      super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Bloc, State>(
        buildWhen: buildWhen,
        builder: (context, state) {
          return TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: S.of(context)!.verificationCode,
              hintText: S.of(context)!.verificationCodeHint,
              suffixIcon: _getSuffixIcon(context),
              errorText: errorText(),
            ),
            onChanged: onChanged,
          );
        });
  }

  Widget _getSuffixIcon(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.update, color: Colors.grey),
      onPressed: () {
        resendCode();
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
              SnackBar(content: Text(S.of(context)!.confirmation_code_sent)));
        _controller.clear();
      },
    );
  }
}
