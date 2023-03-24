import 'dart:async';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:osh_remote/models/email.dart';
import 'package:osh_remote/models/models.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final exceptionStreamController = StreamController<Exception>();
  final AuthenticationRepository _authenticationRepository;

  SignInBloc({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(SignInState(
            email: const Email.pure(),
            password: const Password.pure(),
            isSignedIn: false,
            inProgress: false)) {
    on<SignInUsernameChanged>(_onUsernameChanged);
    on<SignInPasswordChanged>(_onPasswordChanged);
    on<SignInLogoutRequested>(_onLogoutRequested);
    on<SignInLoginRequested>(_onLoginRequested);
    on<SignInFetchSessionRequested>(_onFetchSessionRequested);
  }

  Stream<Exception> get exceptionStream async* {
    yield* exceptionStreamController.stream;
  }

  bool isConfirmAvailable() {
    return state.email.isValid() && state.password.isValid();
  }

  void _onUsernameChanged(
      SignInUsernameChanged event, Emitter<SignInState> emit) {
    emit(state.copyWith(email: Email(value: event.email)));
  }

  void _onPasswordChanged(
      SignInPasswordChanged event, Emitter<SignInState> emit) {
    emit(state.copyWith(password: Password(value: event.password)));
  }

  Future<void> _onLoginRequested(
      SignInLoginRequested event, Emitter<SignInState> emit) async {
    emit(state.copyWith(inProgress: [true]));
    try {
      SignInResult result = await _authenticationRepository.signIn(
        username: state.email.value,
        password: state.password.value,
      );
      emit(state.copyWith(isSignedIn: [result.isSignedIn]));
    } on Exception catch (e) {
      exceptionStreamController.add(e);
    }
    emit(state.copyWith(inProgress: [false]));
  }

  Future<void> _onLogoutRequested(
      SignInLogoutRequested event, Emitter<SignInState> emit) async {
    emit(state.copyWith(inProgress: [true]));
    try {
      await _authenticationRepository.signOut();
      emit(state.copyWith(isSignedIn: [false]));
    } on Exception catch (e) {
      exceptionStreamController.add(e);
    }
    emit(state.copyWith(inProgress: [false]));
  }

  Future<void> _onFetchSessionRequested(
      SignInFetchSessionRequested event, Emitter<SignInState> emit) async {
    emit(state.copyWith(inProgress: [true]));
    try {
      AuthSession result = await _authenticationRepository.fetchAuthSession();
      emit(state.copyWith(isSignedIn: [result.isSignedIn]));
    } on Exception catch (e) {
      exceptionStreamController.add(e);
    }
    emit(state.copyWith(inProgress: [false]));
  }
}