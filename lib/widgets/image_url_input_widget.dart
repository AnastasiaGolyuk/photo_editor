import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/image_bloc.dart';

class ImageUrlInputWidget extends StatefulWidget {
  const ImageUrlInputWidget({super.key});

  @override
  State<ImageUrlInputWidget> createState() => _ImageUrlInputWidgetState();
}

class _ImageUrlInputWidgetState extends State<ImageUrlInputWidget> {
  final TextEditingController inputController = TextEditingController();

  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: inputController,
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            labelText: 'Enter image URL',
          ),
        ),
        ElevatedButton(
          onPressed: () {
            final url = inputController.text;
            if (url.isNotEmpty) {
              context.read<ImageBloc>().add(LoadImageEvent(url));
            }
          },
          child: const Text('Download'),
        ),
      ],
    );
  }
}
