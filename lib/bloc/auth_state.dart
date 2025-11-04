part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoginSuccess extends AuthState {
  final String uid;
  AuthLoginSuccess(this.uid);
  
}

final class AuthLoginFailure extends AuthState {
  final String msg;
  AuthLoginFailure(this.msg);
}

final class AuthLoading extends AuthState {}




