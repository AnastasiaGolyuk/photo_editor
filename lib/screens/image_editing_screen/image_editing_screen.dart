import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:image/image.dart' as img;

class ImageEditingScreen extends StatefulWidget {
  const ImageEditingScreen(
      {super.key, required this.title, required this.imageBytes});

  final String title;

  final Uint8List imageBytes;

  @override
  State<ImageEditingScreen> createState() => _ImageEditingScreenState();
}

class _ImageEditingScreenState extends State<ImageEditingScreen> {
  Uint8List _imageBytes = Uint8List(0);

  bool _isLoading = false;

  void _setImageBytes(Uint8List bytes) {
    setState(() {
      _imageBytes = bytes;
    });
  }

  void _setIsLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  img.Image? decodeImage() {
    return img.decodeImage(
      widget.imageBytes,
    );
  }

  Uint8List encodeImage(img.Image image) {
    String base64Image = base64Encode(img.encodePng(image));
    return const Base64Decoder().convert(base64Image);
  }

  Future<void> pixelateImage() async {
    _setIsLoading(true);
    final cmd = img.Command()
      ..decodeImage(widget.imageBytes)
      ..hexagonPixelate()
      ..encodePng();
    await cmd.executeThread();
    Uint8List? bytes = await cmd.getBytesThread();
    if (bytes != null) {
      _setImageBytes(bytes);
    }
    _setIsLoading(false);
  }

  Future<void> sketchImage(BuildContext context) async {
    _setIsLoading(true);
    final cmd = img.Command()
      ..decodeImage(widget.imageBytes)
      ..sketch()
      ..encodePng();
    await cmd.executeThread();
    Uint8List? bytes = await cmd.getBytesThread();
    if (bytes != null) {
      _setImageBytes(bytes);
    }
    _setIsLoading(false);
  }

  Future<void> grayscaleImage() async {
    _setIsLoading(true);
    final cmd = img.Command()
      ..decodeImage(widget.imageBytes)
      ..grayscale()
      ..encodePng();
    await cmd.executeThread();
    Uint8List? bytes = await cmd.getBytesThread();
    if (bytes != null) {
      _setImageBytes(bytes);
    }
    _setIsLoading(false);
  }

  void removeFilters() {
    _setImageBytes(widget.imageBytes);
  }

  void showMessage(BuildContext context, String message, String type) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    scaffoldMessenger.showSnackBar(SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: type == 'ERROR' ? Colors.red : Colors.green,
    ));
  }

  @override
  void initState() {
    super.initState();
    _setImageBytes(widget.imageBytes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: [
                  SizedBox(
                    height: 300,
                    child: Image.memory(
                      _imageBytes,
                      fit: BoxFit.contain,
                    ),
                  ),
                  if (_isLoading)
                    Container(
                        height: 300,
                        color: Colors.white.withAlpha(150),
                        child: Center(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const <Widget>[
                                CircularProgressIndicator(),
                                Text('Processing image...')
                              ]),
                        )),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(CupertinoIcons.square_grid_2x2_fill),
                        tooltip: 'Add pixelate filter',
                        onPressed: () {
                          pixelateImage();
                        },
                      ),
                      const Text('Pixelate'),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(CupertinoIcons.pencil),
                        tooltip: 'Add sketch filter',
                        onPressed: () {
                          sketchImage(context);
                        },
                      ),
                      const Text('Sketch'),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(CupertinoIcons.color_filter),
                        tooltip: 'Add grayscale filter',
                        onPressed: () {
                          grayscaleImage();
                        },
                      ),
                      const Text('Grayscale'),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(CupertinoIcons.refresh_thick),
                        color: Colors.red,
                        tooltip: 'Remove filter',
                        onPressed: () {
                          removeFilters();
                        },
                      ),
                      const Text('Remove filter',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(CupertinoIcons.share),
                        color: Colors.green,
                        tooltip: 'Save image',
                        onPressed: () {
                          removeFilters();
                        },
                      ),
                      const Text('Save image',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
