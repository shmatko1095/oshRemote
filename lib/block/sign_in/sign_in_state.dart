part of 'sign_in_bloc.dart';

class SignInState {
  SignInState(
      {required this.email,
      required this.password,
      required this.isSignedIn,
      required this.inProgress});

  Email email;
  Password password;
  bool isSignedIn;
  bool inProgress;

  SignInState copyWith(
      {Email? email,
      Password? password,
      List<bool>? isSignedIn,
      List<bool>? inProgress}) {
    var res = SignInState(
      email: email ?? this.email,
      password: password ?? this.password,
      isSignedIn: isSignedIn?.first ?? this.isSignedIn,
      inProgress: inProgress?.first ?? this.inProgress,
    );

    return res;
  }
}
