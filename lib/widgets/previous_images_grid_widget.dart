import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_editor/services/shared_preferences_service.dart';
import 'package:photo_editor/widgets/image_display_widget.dart';

class PreviousImagesGridWidget extends StatelessWidget {
  const PreviousImagesGridWidget({super.key});

  Future<List<String>> _getAllFilePaths() async {
    return await SharedPreferencesService.getAllFilePaths();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Previously saved images',
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        FutureBuilder<List<String>?>(
          future: _getAllFilePaths(),
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data!.isNotEmpty) {
                return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 5,
                            crossAxisSpacing: 10),
                    itemCount: snapshot.data!.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      final file = File(snapshot.data![index]);
                      return InkWell(
                        child: Image.file(file),
                        onTap: () async {
                          await showDialog(
                              context: context,
                              builder: (_) => ImageDialog(
                                    imageBytes: file.readAsBytesSync(),
                                  ));
                        },
                      );
                    });
              } else {
                return const Text('No previously saved photos');
              }
            } else {
              return const CircularProgressIndicator();
            }
          },
        )
      ],
    );
  }
}

class ImageDialog extends StatelessWidget {
  const ImageDialog({super.key, required this.imageBytes});

  final Uint8List imageBytes;

  @override
  Widget build(BuildContext context) {
    return Dialog(child: ImageDisplayWidget(imageBytes: imageBytes));
  }
}
