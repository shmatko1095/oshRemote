import 'dart:core';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ErrorMessageFactory {
  static String get(Exception? exception, BuildContext context) {
    if (exception == null) {
      return "";
    } else if (exception.runtimeType == UsernameExistsException) {
      return S.of(context)!.usernameExistsException;
    } else if (exception.runtimeType == UserNotFoundException) {
      return S.of(context)!.userNotFoundException;
    } else if (exception.runtimeType == NotAuthorizedException) {
      return S.of(context)!.notAuthorizedException;
    } else if (exception.runtimeType == LimitExceededException) {
      return S.of(context)!.limitExceededException;
    } else if (exception.runtimeType == AuthException) {
      return S.of(context)!.signInFailed;
    } else if (exception.runtimeType == CodeMismatchException) {
      return S.of(context)!.codeMismatchException;
    } else {
      return exception.toString();
    }
  }
}