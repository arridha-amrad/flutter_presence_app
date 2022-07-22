import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TextInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  bool? isReadOnly;
  InputBorder? borderType;
  TextInputType? textInputType;
  String? helperText;

  TextInput({
    Key? key,
    required this.label,
    required this.controller,
    this.borderType = const OutlineInputBorder(),
    this.textInputType = TextInputType.text,
    this.helperText,
    this.isReadOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: isReadOnly!,
      keyboardType: textInputType,
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: borderType,
        helperMaxLines: 5,
        helperText: helperText ?? "",
      ),
    );
  }
}
