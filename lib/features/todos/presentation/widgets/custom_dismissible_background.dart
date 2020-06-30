import 'package:flutter/material.dart';

class CustomDismissibleBackground extends StatelessWidget {
  final Color color;
  final IconData icon;
  final double leftPadding;
  final double rightPadding;

  const CustomDismissibleBackground({
    @required this.color,
    @required this.icon,
    this.leftPadding,
    this.rightPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: EdgeInsets.only(
        right: rightPadding ?? double.infinity,
        left: leftPadding ?? 0,
      ),
      alignment: Alignment.centerRight,
      child: Icon(
        icon,
        color: Colors.white,
        size: 35,
      ),
    );
  }
}
