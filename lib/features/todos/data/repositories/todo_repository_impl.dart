import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../datasources/todo_local_data_source.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/todo.dart';
import '../../domain/repositories/todo_repository.dart';
import '../datasources/todo_remote_datasource.dart';

typedef Future<String> _ManageTodoMethod();

const String NO_INTERNET_CONNECTION =
    'Operation done locally and will be synced to server when internet conncetion restored.\n\nNote: Don\'t Log out before syncing TODOs to server.';
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

  StreamController<List<Todo>> cashedTodosStreamController = StreamController();

  @override
  Future<Either<Failure, Stream<List<Todo>>>> getTodosStream() async {
    if (await networkInfo.isConnected) {
      try {
        //close the cashed stream
        cashedTodosStreamController.close();

        final todosStream = await remoteDataSource.getTodosStream();

        //cashe fetched TODOs
        todosStream.first.then((value) async {
          final cashedTodos = await localDataSource.getCachedTodos();
          final hasCashedData = cashedTodos.length > 0;

          //return if there is cashed data to prevent deleting all local operations
          //which done offline
          if (hasCashedData) {
            print('Checking if there are Local changes');
            if (!_isIdentical(value, cashedTodos)) {
              print('Updating Server Data');
              await remoteDataSource.syncLocalTodosToServer(cashedTodos);
            }
            return;
          }

          localDataSource.cacheListOfTodos(value);
        });

        return Right(todosStream);
      } on ServerException catch (error) {
        return Left(ServerFailure(message: error.message));
      }
    } else {
      final todos = await localDataSource.getCachedTodos();
      try {
        if (todos.isNotEmpty) {
          if (cashedTodosStreamController.isClosed) {
            cashedTodosStreamController = StreamController<List<Todo>>();
          }

          cashedTodosStreamController.sink.add(todos);
          print('Cashed Stream: ' +
              cashedTodosStreamController.stream.toString());

          return Right(cashedTodosStreamController.stream);
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
    //perform insert operation locally
    await localDataSource.insertNewTodo(todo);

    //checkthe connectivity before trying to add changes to stream
    //to avoid Can't add to closed the cashed todos stream error.
    if (!(await networkInfo.isConnected)) {
      if (cashedTodosStreamController.isClosed) {
        cashedTodosStreamController = StreamController<List<Todo>>();
      }
      //sync changes to stream.
      cashedTodosStreamController.sink
          .add(await localDataSource.getCachedTodos());
    }

    return _manageTodo(() async {
      return remoteDataSource.addNewTodo(todo);
    });
  }

  @override
  Future<Either<Failure, String>> deleteTodo(Todo todo) async {
    //perform delete operation locally
    await localDataSource.deleteTodo(todo);

    //checkthe connectivity before trying to add changes to stream
    //to avoid Can't add to closed the cashed todos stream error.
    if (!(await networkInfo.isConnected)) {
      if (cashedTodosStreamController.isClosed) {
        cashedTodosStreamController = StreamController<List<Todo>>();
      }
      //sync changes to stream.
      cashedTodosStreamController.sink
          .add(await localDataSource.getCachedTodos());
    }

    return _manageTodo(() async {
      return remoteDataSource.deleteTodo(todo);
    });
  }

  @override
  Future<Either<Failure, String>> updateTodo(Todo todo) async {
    //perform update operation locally
    await localDataSource.updateTodo(todo);

    //checkthe connectivity before trying to add changes to stream
    //to avoid Can't add to closed the cashed todos stream error.
    if (!(await networkInfo.isConnected)) {
      if (cashedTodosStreamController.isClosed) {
        cashedTodosStreamController = StreamController<List<Todo>>();
      }
      //sync local changes to stream.
      cashedTodosStreamController.sink
          .add(await localDataSource.getCachedTodos());
    }

    return _manageTodo(() async {
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

  bool _isIdentical(List<Todo> remoteTodos, List<Todo> localTodo) {
    if (remoteTodos.length != localTodo.length) return false;

    for (int i = 0; i < remoteTodos.length; i++) {
      if (remoteTodos[i] != localTodo[i]) return false;
    }
    return true;
    // return listEquals(remoteTodos, localTodo);
  }
}
