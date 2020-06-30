import 'package:meta/meta.dart';

import '../../domain/entities/todo.dart';

class TodoModel extends Todo {
  TodoModel({
    @required final String id,
    @required final String title,
    @required final String body,
    @required final bool isDone,
    @required final DateTime date,
  }) : super(
          id: id,
          title: title,
          body: body,
          isDone: isDone,
          date: date,
        );

  factory TodoModel.fromJson(Map<String, dynamic> parsedJson) {
    return TodoModel(
      id: parsedJson['id'],
      title: parsedJson['title'],
      body: parsedJson['body'],
      isDone: parsedJson['isDone'] ?? false,
      date: DateTime.parse(parsedJson['date'] ?? DateTime.now().toString()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'isDone': isDone,
      'date': date.toString(),
    };
  }
}
