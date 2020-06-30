import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final String errorText;
  final int maxLines;
  final TextEditingController controller;

  const CustomTextField({
    @required this.hintText,
    @required this.errorText,
    @required this.controller,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey[400],
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey[400],
          ),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey[400],
          ),
        ),
        filled: true,
        fillColor: Theme.of(context).accentColor.withOpacity(0.2),
      ),
      validator: (String value) {
        if (value.isEmpty) return errorText;
        return null;
      },
    );
  }
}
