part of 'authentication_base_bloc.dart';

enum AuthenticationStep {
  step1,
  step1Done,
  step2,
  step2Done,
  success,
}

class AuthenticationState {
  AuthenticationState({
    required this.email,
    required this.password0,
    required this.password1,
    required this.confirmCode,
    required this.step,
    required this.inProgress,
  });

  Email email;
  Password password0;
  Password password1;
  Password confirmCode;
  AuthenticationStep step;
  bool inProgress;

  AuthenticationState copyWith(
      {Email? email,
      Password? password0,
      Password? password1,
      Password? confirmCode,
      AuthenticationStep? step,
      List<bool>? inProgress}) {
    return AuthenticationState(
      email: email ?? this.email,
      password0: password0 ?? this.password0,
      password1: password1 ?? this.password1,
      confirmCode: confirmCode ?? this.confirmCode,
      step: step ?? this.step,
      inProgress: inProgress?.first ?? this.inProgress,
    );
  }
}
