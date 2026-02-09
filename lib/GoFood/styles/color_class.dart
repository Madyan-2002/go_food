import 'package:flutter/material.dart';

class ColorPage extends StatelessWidget {
  final Color color;

  ColorPage({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: color,
    );
  }
}
