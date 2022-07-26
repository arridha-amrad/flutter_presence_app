import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ButtonLoading extends StatelessWidget {
  final bool isLoading;
  final String label;
  VoidCallback? function;

  ButtonLoading({
    Key? key,
    required this.isLoading,
    required this.label,
    this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: function,
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: Colors.black54,
              ),
            )
          : Text(
              label.toUpperCase(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }
}
