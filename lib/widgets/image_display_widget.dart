import 'dart:typed_data';

import 'package:flutter/material.dart';

class ImageDisplayWidget extends StatelessWidget {
  final Uint8List imageBytes;

  const ImageDisplayWidget({super.key, required this.imageBytes});

  @override
  Widget build(BuildContext context) {
    return
        SizedBox(
          height: 300,
          child: Image.memory(
            imageBytes,
            fit: BoxFit.contain,
          ),
    );
  }
}
