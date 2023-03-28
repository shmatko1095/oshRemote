part of 'sign_in_bloc.dart';

enum SignInStatus { unknown, authorized, unauthorized }

class SignInState {
  SignInState(
      {required this.email,
      required this.password,
      required this.status,
      required this.inProgress});

  Email email;
  Password password;
  SignInStatus status;
  bool inProgress;

  SignInState copyWith(
      {Email? email,
      Password? password,
      SignInStatus? status,
      List<bool>? inProgress}) {
    var res = SignInState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      inProgress: inProgress?.first ?? this.inProgress,
    );

    return res;
  }
}
