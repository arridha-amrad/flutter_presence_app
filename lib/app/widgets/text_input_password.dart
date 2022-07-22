import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TextInputPassword extends StatefulWidget {
  final String label;
  InputBorder? borderType;
  bool? isShowHelperText;
  String? errorText;
  final TextEditingController controller;

  TextInputPassword({
    Key? key,
    required this.label,
    this.borderType = const OutlineInputBorder(),
    required this.controller,
    this.errorText = "",
    this.isShowHelperText = false,
  }) : super(key: key);

  @override
  State<TextInputPassword> createState() => _TextInputPasswordState();
}

class _TextInputPasswordState extends State<TextInputPassword> {
  bool isShow = false;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: !isShow,
      decoration: InputDecoration(
          errorText: widget.errorText == "" ? null : widget.errorText,
          suffixIcon: IconButton(
              onPressed: () => setState(() => isShow = !isShow),
              icon: isShow
                  ? const Icon(
                      Icons.visibility,
                      color: Colors.black,
                    )
                  : const Icon(
                      Icons.visibility_off,
                      color: Colors.black,
                    )),
          labelText: widget.label,
          border: widget.borderType,
          helperMaxLines: 5,
          helperText: widget.isShowHelperText!
              ? "Minimum six characters, at least one letter, one number and one special character."
              : ""),
    );
  }
}
