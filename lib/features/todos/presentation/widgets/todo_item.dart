import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
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
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 4,
      ),
      child: Dismissible(
        key: ValueKey(todo.id),
        background: CustomDismissibleBackground(
          color: Colors.blue,
          icon: Icons.check_circle,
          leftPadding: 15.0,
        ), //TODO: Add Dismiss offset.
        confirmDismiss: (dir) => _confirmTodoDismiss(dir, context),
        secondaryBackground: CustomDismissibleBackground(
          color: Colors.red,
          icon: Icons.delete,
          rightPadding: 15.0,
        ),
        child: Card(
          margin: const EdgeInsets.all(0.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ListTile(
            title: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(todo.title),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    todo.body,
                    maxLines: 4,
                    textAlign:
                        _isArabic(todo.body) ? TextAlign.right : TextAlign.left,
                    textDirection: _isArabic(todo.body)
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 5.0),
                  Text(intl.DateFormat.yMMMd().format(todo.date)),
                ],
              ),
            ),
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
      ),
    );
  }

  Future<bool> _confirmTodoDismiss(direction, context) async {
    if (direction == DismissDirection.endToStart) {
      final isConfirmed =
          await showConfirmationDialog(context, title: 'Delete this TODO?');
      if (isConfirmed) {
        _deleteTodoCallback(context, todo).then((resMsg) {
          displaySnackbar(resMsg, mainPageContext);
        });
      }
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

  bool _isArabic(String text) {
    final arabicRegex = RegExp(r'[ء-ي-_ \.]*$');
    final englishRegex = RegExp(r'[a-zA-Z ]');
    return text.contains(arabicRegex) && !text.startsWith(englishRegex);
  }
}
