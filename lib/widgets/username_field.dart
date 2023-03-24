import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UsernameField<Bloc extends StateStreamable<State>, State> extends StatelessWidget {

  final BlocBuilderCondition? buildWhen;
  final ValueChanged<String>? onChanged;
  final String? Function() errorText;

  const UsernameField({
    this.buildWhen,
    this.onChanged,
    required this.errorText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Bloc, State>(
      buildWhen: buildWhen,
      builder: (context, state) {
        return TextField(
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: S.of(context)!.email,
            hintText: S.of(context)!.enterEmail,
            errorText: errorText(),
          ),
            onChanged: onChanged
        );
      },
    );
  }
}
