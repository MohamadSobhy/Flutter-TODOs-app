import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:todo_list_app/core/usecase/usecase.dart';
import 'package:todo_list_app/features/authentication/domain/usecases/check_logged_in_state.dart';
import 'package:todo_list_app/features/authentication/domain/usecases/log_out.dart';
import 'package:todo_list_app/features/authentication/domain/usecases/login_with_facebook.dart';
import 'package:todo_list_app/features/authentication/domain/usecases/login_with_google.dart';

import '../../domain/entities/user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginWithGoogle loginWithGoogle;
  final LoginWithFacebook loginWithFacebook;
  final LogOut logOut;
  final CheckLoggedInState checkLoggedInState;

  AuthBloc({
    @required this.logOut,
    @required this.loginWithGoogle,
    @required this.loginWithFacebook,
    @required this.checkLoggedInState,
  });

  @override
  AuthState get initialState => AuthInitial();

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is LoginWithGoogleEvent) {
      yield LoadingState();

      final loginWithGoogleEither = await loginWithGoogle(NoParam());

      yield loginWithGoogleEither.fold(
        (failure) => ErrorState(message: failure.message),
        (user) => LoggedInState(userData: user),
      );
    } else if (event is LoginWithFacebookEvent) {
      yield LoadingState();

      final loginWithFacebookEither = await loginWithFacebook(NoParam());

      yield loginWithFacebookEither.fold(
        (failure) => ErrorState(message: failure.message),
        (user) => LoggedInState(userData: user),
      );
    } else if (event is LogOutEvent) {
      yield LoadingState();

      final logOutEither = await logOut(NoParam());

      yield logOutEither.fold(
        (failure) => ErrorState(message: failure.message),
        (_) => LoggedOutState(),
      );
    } else if (event is CheckLoggedInStateEvent) {
      yield LoadingState();

      final loggedInStateEither = await checkLoggedInState(NoParam());

      yield loggedInStateEither.fold(
        (_) => LoggedOutState(),
        (user) => LoggedInState(userData: user),
      );
    }
  }
}
