import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller; 
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
    required this.controller, 
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
      controller: controller,
      keyboardType: keyType,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: hint, 
        labelText: lbl,
        contentPadding: const EdgeInsets.all(20),
        counterText: counter,
        helperText: helper,
        prefixIcon: Icon(preIcon),
        suffixIcon: suffixIcon,
      ),
    );
  }
}