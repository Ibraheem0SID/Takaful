import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  const CustomFormField({
    super.key,
    required this.labelText,
    required this.validator,
    required this.onSaved,
  });

  final String labelText;
  final String? Function(String?) validator;
  final Function(String?) onSaved;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: TextFormField(
        textDirection: TextDirection.rtl,
        cursorColor: Colors.black,
        decoration: InputDecoration(
            labelStyle: const TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            floatingLabelAlignment: FloatingLabelAlignment.center,
            labelText: labelText),
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }
}
