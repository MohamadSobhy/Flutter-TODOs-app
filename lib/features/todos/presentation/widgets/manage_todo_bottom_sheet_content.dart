import 'package:flutter/material.dart';
import 'package:todo_list_app/features/todos/data/models/todo_model.dart';
import 'package:todo_list_app/features/todos/domain/entities/todo.dart';

import 'custom_text_field.dart';

class ManageTodoBottomSheetContent extends StatefulWidget {
  final Todo oldTodo;
  final Function(Todo) onSaveButtonClicked;

  const ManageTodoBottomSheetContent({
    @required this.oldTodo,
    @required this.onSaveButtonClicked,
  });

  @override
  _ManageTodoBottomSheetContentState createState() =>
      _ManageTodoBottomSheetContentState();
}

class _ManageTodoBottomSheetContentState
    extends State<ManageTodoBottomSheetContent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  @override
  void initState() {
    if (widget.oldTodo != null) {
      _titleController.text = widget.oldTodo.title;
      _bodyController.text = widget.oldTodo.body;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15.0),
              Text('Title'),
              CustomTextField(
                controller: _titleController,
                hintText: 'TODO\'s title!',
                errorText: 'Title can\'t be empty.',
              ),
              SizedBox(height: 15.0),
              Text('Body'),
              Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: CustomTextField(
                  controller: _bodyController,
                  hintText: 'TODO\'s body!',
                  errorText: 'Body can\'t be empty.',
                  maxLines: 5,
                ),
              ),
              SizedBox(height: 15.0),
              Align(
                alignment: Alignment.centerRight,
                child: FlatButton(
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  onPressed: () {
                    final isValid = _formKey.currentState.validate();
                    if (isValid) {
                      _onValidationSuccess();
                    }
                  },
                  child: Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onValidationSuccess() {
    Todo newTodo;
    if (widget.oldTodo != null) {
      newTodo = TodoModel(
        id: widget.oldTodo.id,
        title: _titleController.text.trim(),
        body: _bodyController.text.trim(),
        isDone: widget.oldTodo.isDone,
        date: DateTime.now(),
      );
    } else {
      newTodo = TodoModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        body: _bodyController.text.trim(),
        isDone: false,
        date: DateTime.now(),
      );
    }

    widget.onSaveButtonClicked(newTodo);
    Navigator.of(context).pop();
  }
}
