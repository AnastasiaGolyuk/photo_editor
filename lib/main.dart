import 'package:flutter/material.dart';
import 'package:photo_editor/screens/image_loading_screen/image_loading_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ImageLoadingScreen(title: 'Photo Editor - Download Image'),
      debugShowCheckedModeBanner: false,
    );
  }
}
