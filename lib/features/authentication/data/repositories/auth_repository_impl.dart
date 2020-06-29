import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

const String NO_INTERNET_CONNECTION =
    'Connection failed: please check your internet connection.';

typedef Future<UserModel> _LoginWithGoogleOrFacebook();

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    @required this.remoteDataSource,
    @required this.localDataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> loginWithFaceBook() async {
    return _login(() => remoteDataSource.loginWithFacebook());
  }

  @override
  Future<Either<Failure, User>> loginWithGoogle() async {
    return _login(() => remoteDataSource.loginWithGoogle());
  }

  Future<Either<Failure, User>> _login(
      _LoginWithGoogleOrFacebook loginMethod) async {
    if (await networkInfo.isConnected) {
      try {
        final userData = await loginMethod();

        localDataSource.casheUserData(userData);

        return Right(userData);
      } on ServerException catch (error) {
        return Left(ServerFailure(message: error.message));
      }
    } else {
      return Left(NetworkFailure(message: NO_INTERNET_CONNECTION));
    }
  }

  @override
  Future<Either<Failure, void>> logOut() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.logOut();

        localDataSource.clear();

        return Right(result);
      } on ServerException catch (error) {
        return Left(ServerFailure(message: error.message));
      }
    } else {
      return Left(NetworkFailure(message: NO_INTERNET_CONNECTION));
    }
  }

  @override
  Future<Either<Failure, User>> checkLoggedInState() async {
    try {
      final user = await localDataSource.getUserData();

      return Right(user);
    } on UserNotFoundException catch (error) {
      return Left(UserNotFoundFailure(message: error.message));
    }
  }
}
