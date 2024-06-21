import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/image_bloc.dart';

class ImageSaveButtonWidget extends StatelessWidget {
  final Uint8List imageBytes;

  const ImageSaveButtonWidget({super.key, required this.imageBytes});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.save_alt_outlined),
          tooltip: 'Save image',
          onPressed: () {
            context.read<ImageBloc>().add(SaveImageEvent(imageBytes));
          },
        ),
        const Text('Save image'),
      ],
    );
  }
}