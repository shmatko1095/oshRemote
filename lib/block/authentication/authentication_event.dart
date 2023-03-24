part of 'authentication_base_bloc.dart';

abstract class AuthenticationEvent {
  const AuthenticationEvent();
}

class AuthenticationUsernameChanged extends AuthenticationEvent {
  const AuthenticationUsernameChanged(this.email);

  final String email;
}

class AuthenticationPassword0Changed extends AuthenticationEvent {
  const AuthenticationPassword0Changed(this.password);

  final String password;
}

class AuthenticationPassword1Changed extends AuthenticationEvent {
  const AuthenticationPassword1Changed(this.password);

  final String password;
}

class AuthenticationConfirmCodeChanged extends AuthenticationEvent {
  const AuthenticationConfirmCodeChanged(this.code);

  final String code;
}

class AuthenticationResendCodeRequested extends AuthenticationEvent {
  const AuthenticationResendCodeRequested();
}

class AuthenticationConfirmEvent extends AuthenticationEvent {
  const AuthenticationConfirmEvent();
}
