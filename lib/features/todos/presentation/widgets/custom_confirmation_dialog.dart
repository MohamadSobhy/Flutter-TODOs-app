import 'package:flutter/material.dart';

class CustomConfirmationDialog extends StatelessWidget {
  final String title;
  final Function() onCancelPressed;
  final Function() onOkPressed;

  const CustomConfirmationDialog({
    @required this.title,
    @required this.onCancelPressed,
    @required this.onOkPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Text(title),
      ),
      actions: [
        FlatButton(
          onPressed: onCancelPressed,
          child: Text('Cancel'),
        ),
        FlatButton(
          onPressed: onOkPressed,
          child: Text('OK'),
        ),
      ],
    );
  }
}
