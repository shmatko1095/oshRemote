import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:osh_remote/widgets/sized_box_elevated_button.dart';

class ConfirmButton<Bloc extends StateStreamable<State>, State>
    extends StatelessWidget {
  final Text text;
  final bool Function() isInProgress;
  final Function()? Function() onPressed;

  const ConfirmButton(
      {required this.text,
      required this.isInProgress,
      required this.onPressed,
      super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Bloc, State>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        return isInProgress()
            ? const CircularProgressIndicator()
            : SizedBoxElevatedButton(text: text, onPressed: onPressed);
      },
    );
  }
}
