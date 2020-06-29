import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list_app/core/network/network_info.dart';
import 'package:todo_list_app/features/authentication/data/datasources/auth_remote_datasource.dart';
import 'package:todo_list_app/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:todo_list_app/features/authentication/domain/repositories/auth_repository.dart';
import 'package:todo_list_app/features/authentication/domain/usecases/check_logged_in_state.dart';
import 'package:todo_list_app/features/authentication/domain/usecases/log_out.dart';
import 'package:todo_list_app/features/authentication/domain/usecases/login_with_facebook.dart';
import 'package:todo_list_app/features/authentication/domain/usecases/login_with_google.dart';
import 'package:todo_list_app/features/authentication/presentation/bloc/auth_bloc.dart';

import 'features/authentication/data/datasources/auth_local_datasource.dart';

final servLocator = GetIt.instance;

Future<void> init() async {
  //! Bloc
  servLocator.registerFactory(
    () => AuthBloc(
      logOut: servLocator(),
      loginWithGoogle: servLocator(),
      loginWithFacebook: servLocator(),
      checkLoggedInState: servLocator(),
    ),
  );

  //! UseCases
  servLocator.registerLazySingleton(
    () => LoginWithFacebook(repository: servLocator()),
  );
  servLocator.registerLazySingleton(
    () => LoginWithGoogle(repository: servLocator()),
  );
  servLocator.registerLazySingleton(
    () => LogOut(repository: servLocator()),
  );
  servLocator.registerLazySingleton(
    () => CheckLoggedInState(repository: servLocator()),
  );

  //! Repository
  servLocator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: servLocator(),
      localDataSource: servLocator(),
      networkInfo: servLocator(),
    ),
  );

  //! Core
  servLocator.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  //! Data Sources.
  servLocator.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: servLocator(),
      googleSignIn: servLocator(),
    ),
  );

  servLocator.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(preferences: servLocator()),
  );

  //! External Libs
  servLocator.registerLazySingleton(() => FirebaseAuth.instance);
  servLocator.registerLazySingleton(() => GoogleSignIn());

  final preferences = await SharedPreferences.getInstance();
  servLocator.registerLazySingleton(() => preferences);
}
