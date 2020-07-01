import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
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
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isArabicText = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      maxLines: widget.maxLines,
      textAlign: _isArabicText ? TextAlign.right : TextAlign.left,
      textDirection: _isArabicText ? TextDirection.rtl : TextDirection.ltr,
      decoration: InputDecoration(
        hintText: widget.hintText,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Colors.grey[200],
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Colors.grey[200],
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Colors.grey[200],
          ),
        ),
        filled: true,
        fillColor: Theme.of(context).accentColor.withOpacity(0.2),
      ),
      onChanged: _checkForArabicLetter,
      validator: (String value) {
        if (value.isEmpty) return widget.errorText;
        return null;
      },
    );
  }

  void _checkForArabicLetter(String text) {
    final arabicRegex = RegExp(r'[ء-ي-_ \.]*$');
    final englishRegex = RegExp(r'[a-zA-Z ]');
    if (text.isNotEmpty &&
        text.contains(arabicRegex) &&
        !text.startsWith(englishRegex)) {
      _isArabicText = true;
    } else {
      _isArabicText = false;
    }
    setState(() {});
  }
}
