part of 'sign_in_bloc.dart';

abstract class SignInEvent {
  const SignInEvent();
}

class SignInUsernameChanged extends SignInEvent {
  const SignInUsernameChanged(this.email);

  final String email;
}

class SignInPasswordChanged extends SignInEvent {
  const SignInPasswordChanged(this.password);

  final String password;
}

class SignInLoginRequested extends SignInEvent {
  const SignInLoginRequested();
}

class SignInDemo extends SignInEvent {
  const SignInDemo();
}

class SignInLogoutRequested extends SignInEvent {
  const SignInLogoutRequested();
}

class SignInFetchUserDataRequested extends SignInEvent {
  const SignInFetchUserDataRequested();
}

class SignedInEvent extends SignInEvent {
  const SignedInEvent();
}

class SignedOutEvent extends SignInEvent {
  const SignedOutEvent();
}