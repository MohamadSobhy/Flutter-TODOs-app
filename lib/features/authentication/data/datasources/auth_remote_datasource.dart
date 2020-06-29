import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';
import 'package:todo_list_app/core/errors/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  /// uses the Firebase and GoogleSignIn plugins to perform
  /// login with google operation.
  ///
  /// returns [UserModel] object which holds the logged in user data.
  /// throws [ServerException] for all errors.
  Future<UserModel> loginWithGoogle();

  /// uses the Firebase and flutter_facebook_login plugins to perform
  /// login with facebook operation.
  ///
  /// returns [UserModel] object which holds the logged in user data.
  /// throws [ServerException] for all errors.
  Future<UserModel> loginWithFacebook();

  /// uses FirebaseAuth, GoogleSignIn and flutter_facebook_login plugins
  /// to perform log out operation.
  ///
  /// throws [ServerException] for all errors.
  Future<void> logOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;
  //final FacebookLogin facebookLogin;

  AuthRemoteDataSourceImpl({
    @required this.firebaseAuth,
    @required this.googleSignIn,
    //@required this.facebookLogin,
  });

  @override
  Future<void> logOut() async {
    try {
      await googleSignIn.signOut();
      await firebaseAuth.signOut();
    } catch (err) {
      throw ServerException(message: err.toString());
    }
  }

  @override
  Future<UserModel> loginWithFacebook() {
    // TODO: implement loginWithFacebook
    throw UnimplementedError();
  }

  @override
  Future<UserModel> loginWithGoogle() async {
    try {
      final googleAccount = await googleSignIn.signIn();
      final googleAuth = await googleAccount.authentication;

      final authCredential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );
      final authResult =
          await firebaseAuth.signInWithCredential(authCredential);

      final userData = UserModel(
        id: authResult.user.uid,
        name: authResult.user.displayName,
        email: authResult.user.email,
        imageUrl: authResult.user.photoUrl,
      );

      return userData;
    } on PlatformException catch (err) {
      throw ServerException(message: err.message);
    } catch (error) {
      throw ServerException(message: error.toString());
    }
  }
}
