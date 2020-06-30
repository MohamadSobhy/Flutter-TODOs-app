import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:todo_list_app/core/errors/exceptions.dart';
import 'package:todo_list_app/core/network/network_info.dart';
import 'package:todo_list_app/features/authentication/data/repositories/auth_repository_impl.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/todo.dart';
import '../../domain/repositories/todo_repository.dart';
import '../datasources/todo_remote_datasource.dart';

typedef Future<String> _ManageTodoMethod();

class TodoRepositoryImpl implements TodoRepository {
  final TodoRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  TodoRepositoryImpl({
    @required this.networkInfo,
    @required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, Stream<List<Todo>>>> getTodosStream() async {
    if (await networkInfo.isConnected) {
      try {
        final todosStream = await remoteDataSource.getTodosStream();
        return Right(todosStream);
      } on ServerException catch (error) {
        return Left(ServerFailure(message: error.message));
      }
    } else {
      return Left(NetworkFailure(message: NO_INTERNET_CONNECTION));
    }
  }

  @override
  Future<Either<Failure, String>> addNewTodo(Todo todo) async {
    return _manageTodo(() => remoteDataSource.addNewTodo(todo));
  }

  @override
  Future<Either<Failure, String>> deleteTodo(Todo todo) async {
    return _manageTodo(() => remoteDataSource.deleteTodo(todo));
  }

  @override
  Future<Either<Failure, String>> updateTodo(Todo todo) async {
    return _manageTodo(() => remoteDataSource.updateTodo(todo));
  }

  Future<Either<Failure, String>> _manageTodo(_ManageTodoMethod method) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await method();
        return Right(result);
      } on ServerException catch (err) {
        return Left(ServerFailure(message: err.message));
      }
    } else {
      return Left(NetworkFailure(message: NO_INTERNET_CONNECTION));
    }
  }
}
