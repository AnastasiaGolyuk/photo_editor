import 'package:flutter/material.dart';


class ErrorDialogWidget extends StatelessWidget {
  final String message;
  final VoidCallback onClose;

  const ErrorDialogWidget({
    super.key,
    required this.message, required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Error'),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
            onClose();
          },
        ),
      ],
    );
  }
}