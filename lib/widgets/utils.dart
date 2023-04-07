import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const padding = EdgeInsets.only(left: 32, right: 32, top: 48, bottom: 16);

void showSnackBar(BuildContext context, String message) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      content: Text(message),
    ),
  );
}

void showAlertDialog(BuildContext context, Exception exception) {
  late final String msg;
  if (exception.runtimeType == UsernameExistsException) {
    msg = S.of(context)!.usernameExistsException;
  } else if (exception.runtimeType == UserNotFoundException) {
    msg = S.of(context)!.userNotFoundException;
  } else if (exception.runtimeType == AuthNotAuthorizedException) {
    msg = S.of(context)!.notAuthorizedException;
  } else if (exception.runtimeType == LimitExceededException) {
    msg = S.of(context)!.limitExceededException;
  } else if (exception.runtimeType == AuthException) {
    msg = S.of(context)!.signInFailed;
  } else {
    msg = exception.toString();
  }

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        content: SingleChildScrollView(
          child: Text(msg),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(S.of(context)!.ok),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Widget getSizedCircularProgressIndicator() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: const <Widget>[
      SizedBox(
        width: 30,
        height: 30,
        child: CircularProgressIndicator(),
      )
    ],
  );
}
