import 'package:flutter/material.dart';

/// Widget to show loading process.
class ImageLoadingWidget extends StatelessWidget {
  final String message;

  const ImageLoadingWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SizedBox(
          height: 150,
        ),
        const SizedBox(
          height: 50.0,
          width: 50.0,
          child: Center(child: CircularProgressIndicator()),
        ),
        const SizedBox(
          height: 20,
        ),
        Center(
          child: Text(message),
        ),
      ],
    );
  }
}
