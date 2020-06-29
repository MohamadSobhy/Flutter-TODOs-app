import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class Failure extends Equatable {
  final String message;

  Failure({@required this.message});
}

class NetworkFailure extends Failure {
  final String message;

  NetworkFailure({@required this.message});

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  final String message;

  ServerFailure({@required this.message});

  @override
  List<Object> get props => [message];
}

class CasheFailure extends Failure {
  final String message;

  CasheFailure({@required this.message});

  @override
  List<Object> get props => [message];
}

class UserNotFoundFailure extends Failure {
  final String message;

  UserNotFoundFailure({@required this.message});

  @override
  List<Object> get props => [message];
}
