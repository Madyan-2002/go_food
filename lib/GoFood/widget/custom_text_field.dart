import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextInputType keyType;
  final String hint;
  final String lbl;
  final String? counter;
  final String? helper;
  final IconData preIcon;
  final Widget? suffixIcon;
  final bool obscure;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    this.suffixIcon,
    required this.keyType,
    required this.hint,
    this.counter,
    required this.lbl,
    this.helper,
    required this.preIcon,
    this.obscure = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      obscureText: obscure,
      // controller: emailController,
      keyboardType: keyType,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hint: Text(hint),
        labelText: lbl,
        contentPadding: EdgeInsets.all(20),
        counterText: counter,
        helperText: helper,
        enabledBorder: OutlineInputBorder(),
        prefixIcon: Icon(preIcon),
        suffixIcon: suffixIcon,
      ),
    );
  }
}
