import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:osh_remote/block/authentication/authentication_base_bloc.dart';

class UserConfirmationBloc extends AuthenticationBaseBloc {
  UserConfirmationBloc({required super.authenticationRepository});

  @override
  Future<void> authenticate(Emitter<AuthenticationState> emit) async {
    emit(state.copyWith(inProgress: [true]));
    try {
      await authenticationRepository.resendSignUpCode(
          username: state.email.value);
      emit(state.copyWith(step: AuthenticationStep.step1Done));
      emit(state.copyWith(step: AuthenticationStep.step2));
    } on Exception catch (e) {
      exceptionStreamController.add(e);
    }
    emit(state.copyWith(inProgress: [false]));
  }

  @override
  Future<void> authenticateConfirmation(
      Emitter<AuthenticationState> emit) async {
    emit(state.copyWith(inProgress: [true]));
    try {
      await authenticationRepository.confirmSignUp(
          username: state.email.value, code: state.confirmCode.value);
      emit(state.copyWith(step: AuthenticationStep.step2Done));
      emit(state.copyWith(step: AuthenticationStep.success));
    } on Exception catch (e) {
      exceptionStreamController.add(e);
    }
    emit(state.copyWith(inProgress: [false]));
  }

  @override
  bool isConfirmAvailable() {
    bool result = false;
    if (state.step == AuthenticationStep.step1) {
      result = state.email.isValid();
    }
    if (state.step == AuthenticationStep.step2) {
      result = state.email.isValid() && state.confirmCode.isValid();
    }
    return result;
  }
}
