import 'package:flutter/material.dart';

class ColorClass extends StatelessWidget {
  final Color color;
  static Color primary = Color.fromARGB(255, 250, 86, 86);
  static Color headLines = Colors.white;

  ColorClass({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: color,
    );
  }
}
