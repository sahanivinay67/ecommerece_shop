import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthLoginEvent>(login);

    on<AuthLogoutEvent>((event, emit) {
      Future.delayed(Duration(seconds: 3)).then((value) {
        emit(AuthInitial());
      });
    });
  }
}

void login(AuthLoginEvent event, Emitter<AuthState> emit) async {
  emit(AuthLoading());
  final String mail = event.email;
  final String password = event.password;

  if (password.length < 4) {
    emit(AuthLoginFailure('Password must be at least 4 characters'));
    return;
  }

  await Future.delayed(Duration(seconds: 2)).then((value) {
    emit(AuthLoginSuccess(mail));
  });
}
