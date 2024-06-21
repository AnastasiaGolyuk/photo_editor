import 'package:flutter/material.dart';

class ImageLoadingWidget extends StatelessWidget {
  final String message;

  const ImageLoadingWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            const CircularProgressIndicator(),
            Text(message),
          ],
        ),
      ),
    );
  }
}