part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class LoginWithGoogleEvent extends AuthEvent {
  @override
  List<Object> get props => [];
}

class LoginWithFacebookEvent extends AuthEvent {
  @override
  List<Object> get props => [];
}

class CheckLoggedInStateEvent extends AuthEvent {
  @override
  List<Object> get props => [];
}

class LogOutEvent extends AuthEvent {
  @override
  List<Object> get props => [];
}
