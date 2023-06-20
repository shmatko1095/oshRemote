part of 'sign_in_bloc.dart';

enum SignInStatus { unknown, demo, authorized, unauthorized }

class SignInState {
  SignInState(
      {required this.user,
      required this.email,
      required this.password,
      required this.status,
      required this.inProgress});

  User user;
  Email email;
  Password password;
  SignInStatus status;
  bool inProgress;

  SignInState copyWith(
      {User? user,
      Email? email,
      Password? password,
      SignInStatus? status,
      List<bool>? inProgress}) {
    return SignInState(
      user: user ?? this.user,
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      inProgress: inProgress?.first ?? this.inProgress,
    );
  }
}
