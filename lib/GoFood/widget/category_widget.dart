import 'package:flutter/material.dart';

class CategoryWidget extends StatelessWidget {
  final Color colorBg;
  final String text;
  final Color txtColor;
  final void Function()? onTap;
  const CategoryWidget({
    super.key,
    required this.colorBg,
    required this.text,
    required this.onTap,
    required this.txtColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: InkWell(
        onTap: onTap,
        child: Card(
          elevation: 15,
          color: colorBg,
          child: Center(
            child: Text(
              text,
              style: Theme.of(
                context,
              ).textTheme.titleMedium!.copyWith(color: txtColor),
            ),
          ),
        ),
      ),
    );
  }
}
