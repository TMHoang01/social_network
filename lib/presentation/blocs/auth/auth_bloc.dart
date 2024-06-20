import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_network/domain/models/user_model.dart';
import 'package:social_network/domain/repository/auth_repository.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    // check go on app
    on<CheckAuthRequested>((event, emit) async {
      try {
        await _getCurrentUser(emit);
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(UnAuthenticated());
      }
    }, transformer: sequential());
    on<SignInRequested>(_signInWithEmailAndPassword, transformer: sequential());

    on<SignUpRequested>(_signUp, transformer: sequential());

    on<GoogleSignInRequested>(_signInWithGoogle, transformer: sequential());

    on<SignOutRequested>(_signOut, transformer: sequential());

    on<AuthLoginPrefilled>(_loginPrefilled, transformer: sequential());
  }

  Future<void> _getCurrentUser(Emitter<AuthState> emit) async {
    final user = await authRepository.getCurrentUser();
    if (user != null) {
      if (user.roles == null) {
        emit(AuthRegisterNeedInfo());
        return;
      }
      if (user.status != StatusUser.active) {
        emit(AuthRegisterNeedVerify());
        return;
      }

      emit(Authenticated(user));
    } else {
      emit(UnAuthenticated());
    }
  }

  FutureOr<void> _signOut(event, emit) async {
    emit(AuthLoginLoading());
    await authRepository.signOut();
    emit(UnAuthenticated());
  }

  FutureOr<void> _signInWithGoogle(event, emit) async {
    emit(AuthLoginLoading());
    try {
      await authRepository.signInWithGoogle();
      await _getCurrentUser(emit);
    } catch (e) {
      authRepository.signOut();
      emit(AuthError(e.toString()));
      emit(UnAuthenticated());
    }
  }

  FutureOr<void> _signInWithEmailAndPassword(event, emit) async {
    emit(AuthLoginLoading());
    try {
      await authRepository.signInWithEmailAndPassword(
          email: event.email, password: event.password);
      await _getCurrentUser(emit);
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(UnAuthenticated());
    }
  }

  FutureOr<void> _signUp(event, emit) async {
    emit(AuthRegisterLoading());
    try {
      await authRepository.signUp(email: event.email, password: event.password);
      await _getCurrentUser(emit);

      emit(AuthRegisterSuccess());
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(UnAuthenticated());
    }
  }

  FutureOr<void> _loginPrefilled(
      AuthLoginPrefilled event, Emitter<AuthState> emit) async {
    // delay 1s for user see the prefilled email and password
    await Future.delayed(const Duration(seconds: 1));
    emit(AuthLoginInitial(email: event.email, password: event.password));
  }

  void _onAuthStart(AuthInitial event, Emitter<AuthState> emit) {
    final user = authRepository.getCurrentUser();
  }
}
