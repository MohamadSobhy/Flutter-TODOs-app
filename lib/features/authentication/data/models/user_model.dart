import 'package:meta/meta.dart';

import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    @required String id,
    @required String name,
    @required String email,
    @required String imageUrl,
  }) : super(name: name, email: email, imageUrl: imageUrl);

  factory UserModel.fromJson(Map<String, dynamic> parsedJson) {
    return UserModel(
      id: parsedJson['id'],
      name: parsedJson['displayName'],
      email: parsedJson['email'],
      imageUrl: parsedJson['photoUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'displayName': name,
      'email': email,
      'photoUrl': imageUrl,
    };
  }
}
