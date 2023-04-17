import 'dart:core';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:osh_remote/block/mqtt_client/exeptions.dart';

class ErrorMessageFactory {
  static String get(Exception? exception, BuildContext context) {
    if (exception == null) {
      return "";
    } else if (exception.runtimeType == UsernameExistsException) {
      return S.of(context)!.usernameExistsException;
    } else if (exception.runtimeType == UserNotFoundException) {
      return S.of(context)!.userNotFoundException;
    } else if (exception.runtimeType == AuthNotAuthorizedException) {
      return S.of(context)!.notAuthorizedException;
    } else if (exception.runtimeType == LimitExceededException) {
      return S.of(context)!.limitExceededException;
    } else if (exception.runtimeType == AuthException) {
      return S.of(context)!.signInFailed;
    } else if (exception.runtimeType == CodeMismatchException) {
      return S.of(context)!.codeMismatchException;
    } else if (exception.runtimeType == NoIotDeviceFound) {
      return S.of(context)!.noIotDeviceFoundException;
    } else if (exception.runtimeType == SecureCodeIncorrect) {
      return S.of(context)!.secureCodeErrorException;
    } else {
      return exception.toString();
    }
  }
}
