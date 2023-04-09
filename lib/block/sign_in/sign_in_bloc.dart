import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:osh_remote/models/email.dart';
import 'package:osh_remote/models/models.dart';
import 'package:osh_remote/models/user.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final exceptionStreamController = StreamController<Exception>.broadcast();
  final AuthenticationRepository _authenticationRepository;

  SignInBloc(AuthenticationRepository authenticationRepository)
      : _authenticationRepository = authenticationRepository,
        super(SignInState(
            user: User.empty(),
            email: const Email.pure(),
            password: const Password.pure(),
            status: SignInStatus.unknown,
            inProgress: false)) {
    on<SignInUsernameChanged>(_onUsernameChanged);
    on<SignInPasswordChanged>(_onPasswordChanged);
    on<SignInLogoutRequested>(_onLogoutRequested);
    on<SignInLoginRequested>(_onLoginRequested);
    on<SignInFetchUserDataRequested>(_onSignInFetchUserRequested);
  }

  @override
  Future<void> close() async {
    exceptionStreamController.close();
    super.close();
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
      await _authenticationRepository.signIn(
        username: state.email.value,
        password: state.password.value,
      );
      final user = await _fetchUser();
      emit(state.copyWith(
          status: user.userId.isNotEmpty
              ? SignInStatus.authorized
              : SignInStatus.unauthorized,
          user: user));
    } on Exception catch (e) {
      emit(state.copyWith(status: SignInStatus.unauthorized));
      exceptionStreamController.add(e);
    }
    emit(state.copyWith(inProgress: [false]));
  }

  Future<void> _onLogoutRequested(
      SignInLogoutRequested event, Emitter<SignInState> emit) async {
    emit(state.copyWith(inProgress: [true]));
    try {
      await _authenticationRepository.signOut();
      emit(state.copyWith(status: SignInStatus.unauthorized));
    } on Exception catch (e) {
      exceptionStreamController.add(e);
    }
    emit(state.copyWith(inProgress: [false]));
  }

  Future<void> _onSignInFetchUserRequested(
      SignInFetchUserDataRequested event, Emitter<SignInState> emit) async {
    emit(state.copyWith(inProgress: [true]));
    try {
      final user = await _fetchUser();
      emit(state.copyWith(
          status: user.userId.isNotEmpty
              ? SignInStatus.authorized
              : SignInStatus.unauthorized,
          user: user));
    } on Exception catch (e) {
      emit(state.copyWith(status: SignInStatus.unauthorized));
      exceptionStreamController.add(e);
    }
    emit(state.copyWith(inProgress: [false]));
  }

  Future<User> _fetchUser() async {
    final attrib = await _authenticationRepository.fetchUserAttributes();
    String userId = attrib
        .firstWhere((element) =>
            element.userAttributeKey == AuthenticationRepository.SubKey)
        .value;
    String name = attrib
        .firstWhere((element) =>
            element.userAttributeKey == AuthenticationRepository.NameKey)
        .value;
    String email = attrib
        .firstWhere((element) =>
            element.userAttributeKey == AuthenticationRepository.EmailKey)
        .value;
    return User(userId: userId, email: email, name: name);
  }
}
