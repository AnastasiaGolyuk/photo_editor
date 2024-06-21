import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/image_bloc.dart';

class ImageProcessingWidget extends StatelessWidget {
  final Uint8List imageBytes;

  const ImageProcessingWidget({super.key, required this.imageBytes});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconButton(
          icon: const Icon(CupertinoIcons.color_filter),
          tooltip: 'Add grayscale filter',
          onPressed: () {
            context.read<ImageBloc>().add(ProcessImageEvent(imageBytes));
          },
        ),
        const Text('Grayscale'),
      ],
    );
  }
}