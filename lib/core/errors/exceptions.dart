import 'package:meta/meta.dart';

class ServerException implements Exception {
  final String message;

  ServerException({@required this.message});
}

class CasheException implements Exception {
  final String message;

  CasheException({@required this.message});
}

class UserNotFoundException implements Exception {
  final String message;

  UserNotFoundException({@required this.message});
}
