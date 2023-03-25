import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PasswordField<B extends StateStreamable<S>, S> extends StatefulWidget {
  final BlocBuilderCondition? buildWhen;
  final ValueChanged<String>? onChanged;
  final String? Function() errorText;
  final String? labelText;
  final String? hintText;

  const PasswordField(
      {this.buildWhen,
      this.onChanged,
      this.labelText,
      this.hintText,
      required this.errorText,
      super.key});

  @override
  State<StatefulWidget> createState() => _PasswordInputState<B, S>();
}

class _PasswordInputState<B extends StateStreamable<S>, S>
    extends State<PasswordField> {
  bool _hide = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<B, S>(
        buildWhen: widget.buildWhen,
        builder: (context, state) {
          return TextField(
            textInputAction: TextInputAction.next,
            obscureText: _hide,
            decoration: InputDecoration(
              suffixIcon: _getSuffixIcon(),
              labelText: widget.labelText,
              hintText: widget.hintText,
              errorText: widget.errorText(),
            ),
            onChanged: widget.onChanged,
          );
        });
  }

  Widget _getSuffixIcon() {
    return IconButton(
      icon:
          Icon(Icons.remove_red_eye, color: _hide ? Colors.grey : Colors.blue),
      onPressed: () => setState(() {
        _hide = !_hide;
      }),
    );
  }
}
