import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import '../../features/todos/domain/entities/todo.dart';
import '../../features/todos/presentation/widgets/custom_confirmation_dialog.dart';
import '../../features/todos/presentation/widgets/manage_todo_bottom_sheet_content.dart';

mixin AlertsMixin {
  void displaySnackbar(String message, context) {
    Flushbar(
      message: message,
      duration: Duration(seconds: 3),
    ).show(context);
  }

  Future<bool> showManageTodoBottomSheet(
    BuildContext context,
    Function(Todo todo) onSaveButtonClicked, {
    Todo oldTodo,
  }) {
    return showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return ManageTodoBottomSheetContent(
          oldTodo: oldTodo,
          onSaveButtonClicked: onSaveButtonClicked,
        );
      },
    );
  }

  Future<bool> showConfirmationDialog(context, {@required String title}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return CustomConfirmationDialog(
          title: title,
          onCancelPressed: () {
            Navigator.of(context).pop(false);
          },
          onOkPressed: () {
            Navigator.of(context).pop(true);
          },
        );
      },
    );
  }
}
