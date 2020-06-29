import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  /// uses the SharedPreferences plugin to store
  /// the logged in user data.
  ///
  /// throws [CasheException] for all errors.
  Future<void> casheUserData(UserModel userModel);

  Future<UserModel> getUserData();

  /// uses the SharedPreferences plugin to clear
  /// the logged in user data to perform logout operation.
  ///
  /// throws [CasheException] for all errors.
  Future<void> clear();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences preferences;

  AuthLocalDataSourceImpl({@required this.preferences});

  @override
  Future<void> casheUserData(UserModel userModel) async {
    try {
      final userString = json.encode(userModel.toMap());
      await preferences.setString('user', userString);
    } catch (error) {
      throw CasheException(message: error.toString());
    }
  }

  @override
  Future<UserModel> getUserData() async {
    final userDataString = preferences.getString('user');
    if (userDataString != null) {
      final parsedJson = json.decode(userDataString);
      return UserModel.fromJson(parsedJson);
    } else {
      throw UserNotFoundException(
        message: 'Welcome to our app, login now and start chating.',
      );
    }
  }

  @override
  Future<void> clear() async {
    await preferences.remove('user');
  }
}
