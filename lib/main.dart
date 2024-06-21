import 'package:flutter/material.dart';
import 'package:photo_editor/screens/photo_editor_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo Editor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PhotoEditorScreen(title: 'Photo Editor'),
      debugShowCheckedModeBanner: false,
    );
  }
}
