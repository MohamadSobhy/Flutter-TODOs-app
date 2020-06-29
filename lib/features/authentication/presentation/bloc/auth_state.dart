part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();
}

class AuthInitial extends AuthState {
  @override
  List<Object> get props => [];
}

class LoggedInState extends AuthState {
  final User userData;

  LoggedInState({@required this.userData});

  @override
  List<Object> get props => [userData];
}

class LoggedOutState extends AuthState {
  @override
  List<Object> get props => [];
}

class LoadingState extends AuthState {
  @override
  List<Object> get props => [];
}

class ErrorState extends AuthState {
  final String message;

  ErrorState({@required this.message});

  @override
  List<Object> get props => [message];
}
