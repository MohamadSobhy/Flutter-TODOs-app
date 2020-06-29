import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class User extends Equatable {
  final String name;
  final String email;
  final String imageUrl;

  User({
    @required this.name,
    @required this.email,
    @required this.imageUrl,
  });

  @override
  List<Object> get props => [name, email, imageUrl];
}
