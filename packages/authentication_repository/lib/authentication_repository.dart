import 'dart:async';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:authentication_repository/amplifyconfiguration.dart';

class AuthenticationRepository {
  static const NameUserAttributeKey = CognitoUserAttributeKey.name;

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

  Future<ResetPasswordResult> confirmResetPassword(
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

  Future<bool> confirmSignUp(
      {required String username, required String code}) async {
    var result = await Amplify.Auth.confirmSignUp(
        username: username, confirmationCode: code);
    return result.isSignUpComplete;
  }

  Future<SignUpResult> signUp(
      {required String username, required String password,
        required String name}) async {
    final attributes = <CognitoUserAttributeKey, String>{
      NameUserAttributeKey: name,
    };

    return await Amplify.Auth.signUp(username: username, password: password,
        options: CognitoSignUpOptions(userAttributes: attributes));
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

  Future<List<AuthUserAttribute>> fetchUserAttributes() async {
    return await Amplify.Auth.fetchUserAttributes();
  }

  Future<AuthUser> getCurrentUser() async {
    return await Amplify.Auth.getCurrentUser();
  }
}
