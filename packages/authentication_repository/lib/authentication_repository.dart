import 'dart:async';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:authentication_repository/amplifyconfiguration.dart';

enum AuthenticationEvent {
  SignedIn,
  SignedOut,
  SessionExpired,
  UserDeleted,
}

class AuthenticationRepository {
  static const SubKey = CognitoUserAttributeKey.sub;
  static const NameKey = CognitoUserAttributeKey.name;
  static const EmailKey = CognitoUserAttributeKey.email;

  final StreamController<AuthenticationEvent> _eventStreamController =
      StreamController<AuthenticationEvent>();
  late final StreamSubscription<HubEvent> _hubSubscription;

  Stream<AuthenticationEvent> get eventStream => _eventStreamController.stream;

  void startListen() {
    HubChannel<dynamic, HubEvent<dynamic>> channel = HubChannel.Auth;
    _hubSubscription = Amplify.Hub.listen(channel, (hubEvent) {
      switch (hubEvent.eventName) {
        case 'SIGNED_IN':
          _eventStreamController.add(AuthenticationEvent.SignedIn);
          break;
        case 'SIGNED_OUT':
          _eventStreamController.add(AuthenticationEvent.SignedOut);
          break;
        case 'SESSION_EXPIRED':
          _eventStreamController.add(AuthenticationEvent.SessionExpired);
          break;
        case 'USER_DELETED':
          _eventStreamController.add(AuthenticationEvent.UserDeleted);
          break;
      }
    });
  }

  void stopListen() {
    _hubSubscription.cancel();
  }

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
      {required String email,
      required String password,
      required String name}) async {
    final attributes = <CognitoUserAttributeKey, String>{
      NameKey: name,
      EmailKey: email,
    };

    return await Amplify.Auth.signUp(
        username: email,
        password: password,
        options: SignUpOptions(userAttributes: attributes));
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
