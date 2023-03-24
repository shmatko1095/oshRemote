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

class SignInLogoutRequested extends SignInEvent {
  const SignInLogoutRequested();
}

class SignInFetchSessionRequested extends SignInEvent {
  const SignInFetchSessionRequested();
}
