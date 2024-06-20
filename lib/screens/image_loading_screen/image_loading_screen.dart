import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:photo_editor/screens/image_editing_screen/image_editing_screen.dart';

class ImageLoadingScreen extends StatefulWidget {
  const ImageLoadingScreen({super.key, required this.title});

  final String title;

  @override
  State<ImageLoadingScreen> createState() => _ImageLoadingScreenState();
}

class _ImageLoadingScreenState extends State<ImageLoadingScreen> {
  String _url = '';
  Uint8List _imageBytes = Uint8List(0);
  bool _isLoading = false;
  final TextEditingController inputController = TextEditingController();

  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }

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

  void _setUrl(String url) {
    setState(() {
      _url = url;
    });
  }

  Future<void> _fetchImageBytes() async {
    _setIsLoading(true);
    try {
      final http.Response response = await http.get(Uri.parse(_url));
      if (response.statusCode == 200) {
        _setImageBytes(response.bodyBytes);
        _navigateNext();
      } else {
        _showError('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      _showError('Error fetching image: $e');
    } finally {
      _setIsLoading(false);
    }
  }

  void _navigateNext() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageEditingScreen(
          title: 'Photo Editor - Edit Image',
          imageBytes: _imageBytes,
        ),
      ),
    );
  }

  void _fetchImage(String url) {
    _setUrl(url);
    _fetchImageBytes();
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
              TextFormField(
                controller: inputController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter image URL',
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _fetchImage(inputController.text);
                },
                child: const Text('Download'),
              ),
              if (_isLoading)
                SizedBox(
                  height: 300,
                  child: Center(
                    child: Column(children: const <Widget>[
                      CircularProgressIndicator(),
                      Text('Loading image from given URL...')
                    ]),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
