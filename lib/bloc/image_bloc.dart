import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:equatable/equatable.dart';
import 'package:image/image.dart' as img;

part 'image_event.dart';

part 'image_state.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  ImageBloc() : super(ImageInitial()) {
    on<LoadImageEvent>(_onLoadImage);
    on<ProcessImageEvent>(_onProcessImage);
    on<SaveImageEvent>(_onSaveImage);
  }

  Future<void> _onLoadImage(
      LoadImageEvent event, Emitter<ImageState> emit) async {
    emit(ImageLoading());
    try {
      final response = await http.get(Uri.parse(event.imageUrl));
      if (response.statusCode == 200) {
        emit(ImageLoaded(response.bodyBytes));
      } else {
        emit(ImageError('Failed to load image'));
      }
    } catch (e) {
      emit(ImageError(e.toString()));
    }
  }

  Future<void> _onProcessImage(
      ProcessImageEvent event, Emitter<ImageState> emit) async {
    emit(ImageProcessing());
    try {
      final cmd = img.Command()
        ..decodeImage(event.imageBytes)
        ..grayscale()
        ..encodePng();
      await cmd.executeThread();
      Uint8List? bytes = await cmd.getBytesThread();
      if (bytes != null) {
        emit(ImageProcessed(bytes));
      }
    } catch (e) {
      emit(ImageError(e.toString()));
    }
  }

  Future<void> _onSaveImage(
      SaveImageEvent event, Emitter<ImageState> emit) async {
    try {
      final dir = await getTemporaryDirectory();
      var filename = '${dir.path}/SaveImage.png';
      final file = File(filename);
      await file.writeAsBytes(event.imageBytes);
      final params = SaveFileDialogParams(sourceFilePath: file.path);
      final finalPath = await FlutterFileDialog.saveFile(params: params);
      if (finalPath != null) {
        emit(ImageSaved());
      }
    } catch (e) {
      emit(ImageError(e.toString()));
    }
  }
}
