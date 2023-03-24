import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:osh_remote/models/email.dart';
import 'package:osh_remote/models/models.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

abstract class AuthenticationBaseBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBaseBloc({required this.authenticationRepository})
      : super(AuthenticationState(
            email: const Email.pure(),
            password0: const Password.pure(),
            password1: const Password.pure(),
            confirmCode: const Password.pure(),
            step: AuthenticationStep.step1,
            inProgress: false)) {
    on<AuthenticationUsernameChanged>(_onUsernameChanged);
    on<AuthenticationPassword0Changed>(_onPassword0Changed);
    on<AuthenticationPassword1Changed>(_onPassword1Changed);
    on<AuthenticationConfirmCodeChanged>(_onConfirmCodeChanged);
    on<AuthenticationResendCodeRequested>(authenticationCodeResend);
    on<AuthenticationConfirmEvent>(_onConfirmEvent);
  }

  final exceptionStreamController = StreamController<Exception>();

  Stream<Exception> get exceptionStream async* {
    yield* exceptionStreamController.stream;
  }

  final AuthenticationRepository authenticationRepository;

  Future<void> _onConfirmEvent(AuthenticationConfirmEvent event,
      Emitter<AuthenticationState> emit) async {
    switch (state.step) {
      case AuthenticationStep.step1:
        await authenticate(emit);
        break;
      case AuthenticationStep.step2:
        await authenticateConfirmation(emit);
        break;
      default:
        break;
    }
  }

  void _onUsernameChanged(
      AuthenticationUsernameChanged event, Emitter<AuthenticationState> emit) {
    emit(state.copyWith(email: Email(value: event.email)));
  }

  void _onPassword0Changed(
      AuthenticationPassword0Changed event, Emitter<AuthenticationState> emit) {
    emit(state.copyWith(password0: Password(value: event.password)));
  }

  void _onPassword1Changed(
      AuthenticationPassword1Changed event, Emitter<AuthenticationState> emit) {
    emit(state.copyWith(password1: Password(value: event.password)));
  }

  void _onConfirmCodeChanged(AuthenticationConfirmCodeChanged event,
      Emitter<AuthenticationState> emit) {
    emit(state.copyWith(confirmCode: Password(value: event.code, length: 6)));
  }

  Future<void> authenticate(Emitter<AuthenticationState> emit);

  Future<void> authenticateConfirmation(Emitter<AuthenticationState> emit);

  Future<void> authenticationCodeResend(AuthenticationResendCodeRequested event,
      Emitter<AuthenticationState> emit) async {
    try {
      await authenticationRepository.resendSignUpCode(
          username: state.email.value);
    } on Exception catch (e) {
      exceptionStreamController.add(e);
    }
  }

  bool isConfirmAvailable() {
    bool result = false;
    if (state.step == AuthenticationStep.step1) {
      result = state.email.isValid() &&
          state.password0.isValid() &&
          state.password1.isValid() &&
          state.password0.value == state.password1.value;
    }
    if (state.step == AuthenticationStep.step2) {
      result = state.email.isValid() &&
          state.password0.isValid() &&
          state.password1.isValid() &&
          state.password0.value == state.password1.value &&
          state.confirmCode.isValid();
    }
    return result;
  }
}
