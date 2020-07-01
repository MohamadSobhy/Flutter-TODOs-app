import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/todo_repository.dart';

class ClearCashedTodos extends UseCase<void, NoParam> {
  final TodoRepository repository;

  ClearCashedTodos({@required this.repository});

  @override
  Future<Either<Failure, void>> call(NoParam param) {
    return repository.clearCashedTodos();
  }
}
