import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
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
import 'package:todo_list_app/features/todos/data/datasources/todo_local_data_source.dart';
import 'package:todo_list_app/features/todos/data/datasources/todo_remote_datasource.dart';
import 'package:todo_list_app/features/todos/data/repositories/todo_repository_impl.dart';
import 'package:todo_list_app/features/todos/domain/repositories/todo_repository.dart';
import 'package:todo_list_app/features/todos/domain/usecases/add_new_todo.dart';
import 'package:todo_list_app/features/todos/domain/usecases/clear_cashed_todos.dart';
import 'package:todo_list_app/features/todos/domain/usecases/delete_todo.dart';
import 'package:todo_list_app/features/todos/domain/usecases/get_todos_stream.dart';
import 'package:todo_list_app/features/todos/domain/usecases/update_todo.dart';
import 'package:todo_list_app/features/todos/presentation/provider/todos_provider.dart';

import 'features/authentication/data/datasources/auth_local_datasource.dart';
import 'features/todos/data/datasources/database_helper.dart';

final servLocator = GetIt.instance;

Future<void> init() async {
  //! Authentication Feature
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
      facebookLogin: servLocator(),
    ),
  );

  servLocator.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(preferences: servLocator()),
  );

  //! External Libs
  servLocator.registerLazySingleton(() => FirebaseAuth.instance);
  servLocator.registerLazySingleton(() => GoogleSignIn());
  servLocator.registerLazySingleton(() => FacebookLogin());

  final preferences = await SharedPreferences.getInstance();
  servLocator.registerLazySingleton(() => preferences);

  //! Todos Feature

  //! Provider
  servLocator.registerLazySingleton(
    () => TodoProvider(
      getTodoStream: servLocator(),
      addNewToDo: servLocator(),
      updateToDo: servLocator(),
      deleteToDo: servLocator(),
      clearCashedTodos: servLocator(),
    ),
  );

  //! UseCases
  servLocator.registerLazySingleton(
    () => GetTodoStream(
      repository: servLocator(),
    ),
  );

  servLocator.registerLazySingleton(
    () => AddNewToDo(
      repository: servLocator(),
    ),
  );

  servLocator.registerLazySingleton(
    () => UpdateToDo(
      repository: servLocator(),
    ),
  );

  servLocator.registerLazySingleton(
    () => DeleteToDo(
      repository: servLocator(),
    ),
  );
  servLocator.registerLazySingleton(
    () => ClearCashedTodos(
      repository: servLocator(),
    ),
  );

  //! Todo Repository
  servLocator.registerLazySingleton<TodoRepository>(
    () => TodoRepositoryImpl(
      networkInfo: servLocator(),
      remoteDataSource: servLocator(),
      localDataSource: servLocator(),
    ),
  );

  //! Data Sources
  servLocator.registerLazySingleton<TodoRemoteDataSource>(
    () => TodoRemoteDataSourceImpl(
      firestore: servLocator(),
    ),
  );

  //creats the TODOs database for cashing fetched TODOs.
  await DatabaseHelper().createDatabase();

  servLocator.registerLazySingleton<TodoLocalDataSource>(
      () => TodoLocalDataSourceImpl());

  //! Exteranl Libs
  servLocator.registerLazySingleton(() => Firestore.instance);
}
