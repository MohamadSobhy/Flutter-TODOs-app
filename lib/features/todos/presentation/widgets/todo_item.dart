import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/mixins/alerts_mixin.dart';
import '../../domain/entities/todo.dart';
import '../provider/todos_provider.dart';
import 'custom_confirmation_dialog.dart';
import 'custom_dismissible_background.dart';

class TodoItem extends StatelessWidget with AlertsMixin {
  final Todo todo;
  //used when displaying message after deleting the item because it
  //will throw exception when using the context of the removed widget.
  final BuildContext mainPageContext;

  const TodoItem({Key key, this.todo, @required this.mainPageContext})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(todo.id),
      background: CustomDismissibleBackground(
        color: Colors.blue,
        icon: Icons.check_circle,
        leftPadding: 15.0,
      ),
      confirmDismiss: (dir) => _confirmTodoDismiss(dir, context),
      secondaryBackground: CustomDismissibleBackground(
        color: Colors.red,
        icon: Icons.delete,
        rightPadding: 15.0,
      ),
      child: Card(
        child: ListTile(
          title: Text(todo.title),
          subtitle: Text(todo.body),
          trailing: Icon(
            Icons.check_circle_outline,
            color: todo.isDone ? Colors.blue : Colors.grey,
            size: 25,
          ),
          onTap: () => showManageTodoBottomSheet(
            context,
            (todo) => _updateTodoCallback(context, todo),
            oldTodo: todo,
          ),
        ),
      ),
    );
  }

  Future<bool> _confirmTodoDismiss(direction, context) async {
    if (direction == DismissDirection.endToStart) {
      final isConfirmed =
          await showConfirmationDialog(context, title: 'Delete this TODO?');
      if (isConfirmed) {
        _deleteTodoCallback(context, todo).then((resMsg) {
          //check if the todo deleted before dismissing
          if (resMsg.startsWith('Done')) {
            displaySnackbar(resMsg, mainPageContext);
          }
        });
      }
      //cancel dismiss if an error occured
      //return Future.value(false);
    } else {
      final isConfirmed = await showConfirmationDialog(
        context,
        title: 'Mark this TODO as Done?',
      );
      if (isConfirmed) {
        _updateTodoCallback(context, todo..isDone = true);
      }
      return Future.value(false);
    }
  }

  void _updateTodoCallback(context, Todo todo) async {
    final msg =
        await Provider.of<TodoProvider>(context, listen: false).updateTodo(
      todo,
    );
    displaySnackbar(msg, context);
  }

  Future<String> _deleteTodoCallback(context, Todo todo) async {
    final msg =
        await Provider.of<TodoProvider>(context, listen: false).deleteTodo(
      todo,
    );
    //displaySnackbar(msg, context);
    return msg;
  }
}