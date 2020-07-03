import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Todo extends Equatable {
  final String id;
  final String title;
  final String body;
  bool isDone;
  final DateTime date;

  Todo({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.isDone,
    @required this.date,
  });

  @override
  List<Object> get props => [id, title, body, date, isDone];
}
