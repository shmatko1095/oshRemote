import 'dart:async';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:authentication_repository/amplifyconfiguration.dart';

class AuthenticationRepository {
  Future<SignInResult> signIn(
      {required String username, required String password}) async {
    return await Amplify.Auth.signIn(
      username: username,
      password: password,
    );
  }

  Future<SignOutResult> signOut() async {
    return await Amplify.Auth.signOut();
  }

  Future<ResetPasswordResult> resetPassword({required String username}) async {
    return await Amplify.Auth.resetPassword(username: username);
  }

  Future<UpdatePasswordResult> confirmResetPassword(
      {required String username,
      required String password,
      required String code}) async {
    return await Amplify.Auth.confirmResetPassword(
        username: username, newPassword: password, confirmationCode: code);
  }

  Future<ResendSignUpCodeResult> resendSignUpCode(
      {required String username}) async {
    return await Amplify.Auth.resendSignUpCode(username: username);
  }

  Future<SignUpResult> confirmSignUp(
      {required String username, required String code}) async {
    return await Amplify.Auth.confirmSignUp(
        username: username, confirmationCode: code);
  }

  Future<SignUpResult> signUp(
      {required String username, required String password}) async {
    return await Amplify.Auth.signUp(username: username, password: password);
  }

  Future<void> deleteUser() async {
    await Amplify.Auth.deleteUser();
  }

  Future<void> configure() async {
    if (!Amplify.isConfigured) {
      await Amplify.addPlugin(AmplifyAuthCognito());
      await Amplify.configure(amplifyconfig);
    }
  }

  Future<AuthSession> fetchAuthSession() async {
    return await Amplify.Auth.fetchAuthSession();
  }
}
