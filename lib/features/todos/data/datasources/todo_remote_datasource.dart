import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list_app/core/errors/exceptions.dart';

import '../../../../injection_container.dart';
import '../models/todo_model.dart';

abstract class TodoRemoteDataSource {
  Future<Stream<List<TodoModel>>> getTodosStream();
  Future<void> syncLocalTodosToServer(List<TodoModel> todos);
  Future<String> addNewTodo(TodoModel todo);
  Future<String> updateTodo(TodoModel todo);
  Future<String> deleteTodo(TodoModel todo);
}

class TodoRemoteDataSourceImpl implements TodoRemoteDataSource {
  final Firestore firestore;

  TodoRemoteDataSourceImpl({@required this.firestore});

  @override
  Future<String> addNewTodo(TodoModel todo) async {
    try {
      await firestore
          .collection(_getCollectionName())
          .document(todo.id)
          .setData(todo.toMap());

      return 'Done. TODO added succesfully';
    } catch (err) {
      throw ServerException(message: err.toString());
    }
  }

  @override
  Future<String> deleteTodo(TodoModel todo) async {
    try {
      await firestore
          .collection(_getCollectionName())
          .document(todo.id)
          .delete();

      // firestore.runTransaction((transaction) async {
      //   final docSnap = await transaction.get(docRef);
      //   await transaction.delete(docSnap.reference);
      // });

      return 'Done. TODO deleted successfully.';
    } catch (err) {
      throw ServerException(message: err.toString());
    }
  }

  @override
  Future<String> updateTodo(TodoModel todo) async {
    try {
      await firestore
          .collection(_getCollectionName())
          .document(todo.id)
          .updateData(todo.toMap());

      // firestore.runTransaction((transaction) async {
      //   final docSnap = await transaction.get(docRef);
      //   await transaction.update(docSnap.reference, todo.toMap());
      // });

      return 'Done. TODO updated successfully.';
    } catch (err) {
      throw ServerException(message: err.toString());
    }
  }

  @override
  Future<Stream<List<TodoModel>>> getTodosStream() async {
    try {
      final snapshotsStream = firestore
          .collection(_getCollectionName())
          .orderBy('date')
          .snapshots();

      return snapshotsStream.transform(streamTransformer);
    } catch (error) {
      throw ServerException(message: error.toString());
    }
  }

  StreamTransformer<QuerySnapshot, List<TodoModel>> streamTransformer =
      StreamTransformer<QuerySnapshot, List<TodoModel>>.fromHandlers(
    handleData: (snapshot, sink) {
      final todos =
          snapshot.documents.map((e) => TodoModel.fromJson(e.data)).toList();
      sink.add(todos);
    },
  );

  String _getCollectionName() {
    final preferences = servLocator<SharedPreferences>();
    return json.decode(preferences.getString('user'))['email'] + '-todos';
  }

  @override
  Future<void> syncLocalTodosToServer(List<TodoModel> todos) async {
    final snapshot = await firestore
        .collection(
          _getCollectionName(),
        )
        .getDocuments();

    //Delete old TODOs from Firestore
    for (DocumentSnapshot doc in snapshot.documents) {
      await doc.reference.delete();
    }

    //Sync New TODOs to Firestore
    for (TodoModel todo in todos) {
      await addNewTodo(todo);
    }
  }
}
