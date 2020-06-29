import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_list_app/core/errors/failures.dart';

abstract class UseCase<Type, Param> {
  //params parameter will be used with usecases that will need argiments.
  Future<Either<Failure, Type>> call(Param param);
}

class NoParam extends Equatable {
  @override
  List<Object> get props => [];
}
