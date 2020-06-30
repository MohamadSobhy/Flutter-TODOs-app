import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/mixins/alerts_mixin.dart';
import '../../../../core/pages/settings_screen.dart';
import '../../../../main.dart';
import '../../domain/entities/todo.dart';
import '../provider/todos_provider.dart';
import '../widgets/todo_item.dart';

class MyHomePage extends StatelessWidget with AlertsMixin {
  final String title;

  const MyHomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Routes.sailor.navigate(SettingsScreen.routeName);
            },
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder<Stream<List<Todo>>>(
          future: Provider.of<TodoProvider>(context).getTodosStream(),
          builder: (_, snap) {
            if (!snap.hasData) return Text('Loading.......');
            return StreamBuilder<List<Todo>>(
              stream: snap.data,
              builder: (ctx, snapshot) {
                if (!snapshot.hasData) return Text('Loading ...');

                print(snapshot.data);

                if (snapshot.data.isEmpty) {
                  return Text('There are no TODOs. Try adding some now.');
                }

                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (ctx, index) {
                    return TodoItem(
                      todo: snapshot.data[index],
                      mainPageContext: context,
                    );
                  },
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showManageTodoBottomSheet(
            context,
            (Todo todo) => _addNewTodoCallback(context, todo),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).accentColor,
      ),
    );
  }

  void _addNewTodoCallback(context, Todo todo) async {
    final msg =
        await Provider.of<TodoProvider>(context, listen: false).addNewTodo(
      todo,
    );
    displaySnackbar(msg, context);
  }
}
