import 'package:dartz/dartz.dart' show Either;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_app/core/errors/failures.dart';

import '../../../../core/mixins/alerts_mixin.dart';
import '../../../../core/pages/settings_screen.dart';
import '../../../../main.dart';
import '../../domain/entities/todo.dart';
import '../provider/todos_provider.dart';
import '../widgets/todo_item.dart';

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({Key key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with AlertsMixin {
  @override
  Widget build(BuildContext context) {
    final AppBar appBar = _buildAppBar();
    return Scaffold(
      appBar: appBar,
      body: RefreshIndicator(
        onRefresh: () {
          print('refresh');
          setState(() {});
          return Future.delayed(Duration(milliseconds: 500));
        },
        child: Center(
          child: FutureBuilder<Either<Failure, Stream<List<Todo>>>>(
            future: Provider.of<TodoProvider>(context).getTodosStream(),
            builder: (_, snap) {
              if (!snap.hasData) return CircularProgressIndicator();

              return snap.data.fold(
                (failure) {
                  return _buildCenteredErrorMessage(
                      context, appBar, failure.message);
                },
                (todosStream) {
                  return _buildTodosList(todosStream, context, appBar);
                },
              );
            },
          ),
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

  Widget _buildTodosList(
    Stream<List<Todo>> todosStream,
    BuildContext context,
    AppBar appBar,
  ) {
    return StreamBuilder<List<Todo>>(
      stream: todosStream,
      builder: (ctx, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();

        print(snapshot.data);

        if (snapshot.data.isEmpty) {
          return _buildCenteredErrorMessage(
              context, appBar, 'There are no TODOs. Try adding some now.');
        }

        return ListView.builder(
          padding: const EdgeInsets.only(top: 3.0),
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
  }

  ListView _buildCenteredErrorMessage(
      BuildContext context, AppBar appBar, String message) {
    return ListView(
      children: [
        Container(
          height: MediaQuery.of(context).size.height -
              appBar.preferredSize.height -
              MediaQuery.of(context).padding.top,
          child: Text(message),
          alignment: Alignment.center,
        ),
      ],
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0.0,
      title: Text(widget.title),
      actions: [
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            Routes.sailor.navigate(SettingsScreen.routeName);
          },
        ),
      ],
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
