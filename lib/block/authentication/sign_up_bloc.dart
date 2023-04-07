import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:osh_remote/block/authentication/authentication_base_bloc.dart';

class SignUpBloc extends AuthenticationBaseBloc {
  SignUpBloc(AuthenticationRepository authenticationRepository)
      : super(authenticationRepository: authenticationRepository);

  @override
  Future<void> authenticate(Emitter<AuthenticationState> emit) async {
    emit(state.copyWith(inProgress: [true]));
    try {
      await authenticationRepository.signUp(
          username: state.email.value,
          password: state.password0.value,
          name: state.name);
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
    bool result = false;
    try {
      result = await authenticationRepository.confirmSignUp(
          username: state.email.value, code: state.confirmCode.value);
    } on Exception catch (e) {
      exceptionStreamController.add(e);
    }
    if (result) {
      emit(state.copyWith(step: AuthenticationStep.step2Done));
      emit(state.copyWith(step: AuthenticationStep.success));
    }
    emit(state.copyWith(inProgress: [false]));
  }
}
