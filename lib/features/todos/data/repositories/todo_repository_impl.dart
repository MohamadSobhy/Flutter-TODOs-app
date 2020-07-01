import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../../authentication/data/repositories/auth_repository_impl.dart';
import '../datasources/todo_local_data_source.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/todo.dart';
import '../../domain/repositories/todo_repository.dart';
import '../datasources/todo_remote_datasource.dart';

typedef Future<String> _ManageTodoMethod();

const String NO_INTERNET_AND_NO_CASHED_DATA =
    'There are no cashed TODOs. check your internet connection to load them from Server.';

class TodoRepositoryImpl implements TodoRepository {
  final TodoRemoteDataSource remoteDataSource;
  final TodoLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  TodoRepositoryImpl({
    @required this.networkInfo,
    @required this.remoteDataSource,
    @required this.localDataSource,
  });

  @override
  Future<Either<Failure, Stream<List<Todo>>>> getTodosStream() async {
    if (await networkInfo.isConnected) {
      try {
        final todosStream = await remoteDataSource.getTodosStream();

        //cashe fetched TODOs
        todosStream.first.then((value) {
          localDataSource.cacheListOfTodos(value);
          print('TODOs cashed');
        });

        return Right(todosStream);
      } on ServerException catch (error) {
        return Left(ServerFailure(message: error.message));
      }
    } else {
      final todos = await localDataSource.getCachedTodos();
      try {
        if (todos.isNotEmpty) {
          StreamController<List<Todo>> controller = StreamController();
          controller.sink.add(todos);
          print('Cashed Stream' + controller.stream.toString());
          return Right(controller.stream);
        } else {
          return Left(NetworkFailure(message: NO_INTERNET_AND_NO_CASHED_DATA));
        }
      } on CasheException catch (err) {
        return Left(CasheFailure(message: err.message));
      }
    }
  }

  @override
  Future<Either<Failure, String>> addNewTodo(Todo todo) async {
    return _manageTodo(() async {
      if (await networkInfo.isConnected) localDataSource.insertNewTodo(todo);
      return remoteDataSource.addNewTodo(todo);
    });
  }

  @override
  Future<Either<Failure, String>> deleteTodo(Todo todo) async {
    return _manageTodo(() async {
      if (await networkInfo.isConnected) localDataSource.deleteTodo(todo);
      return remoteDataSource.deleteTodo(todo);
    });
  }

  @override
  Future<Either<Failure, String>> updateTodo(Todo todo) async {
    return _manageTodo(() async {
      if (await networkInfo.isConnected) localDataSource.updateTodo(todo);
      return remoteDataSource.updateTodo(todo);
    });
  }

  Future<Either<Failure, String>> _manageTodo(_ManageTodoMethod method) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await method();
        return Right(result);
      } on ServerException catch (err) {
        return Left(ServerFailure(message: err.message));
      } on CasheException catch (err) {
        return Left(CasheFailure(message: err.message));
      }
    } else {
      print('gdgdgd');
      return Left(NetworkFailure(message: NO_INTERNET_CONNECTION));
    }
  }

  @override
  Future<Either<Failure, void>> clearCashedTodos() async {
    try {
      return Right(await localDataSource.clearCachedTodos());
    } on CasheException catch (error) {
      return Left(CasheFailure(message: error.message));
    }
  }
}
