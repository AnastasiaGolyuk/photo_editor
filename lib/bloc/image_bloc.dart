import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:equatable/equatable.dart';
import 'package:image/image.dart' as img;
import 'package:photo_editor/services/shared_preferences_service.dart';

part 'image_event.dart';

part 'image_state.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  ImageBloc() : super(ImageInitial()) {
    on<LoadImageEvent>(_onLoadImage);
    on<ProcessImageEvent>(_onProcessImage);
    on<SaveImageEvent>(_onSaveImage);
    on<ErrorDismissedEvent>(_onErrorDismissed);
  }

  Future<void> _onLoadImage(
      LoadImageEvent event, Emitter<ImageState> emit) async {
    emit(ImageLoading());
    try {
      final response = await http.get(Uri.parse(event.imageUrl));
      if (response.statusCode == 200) {
        emit(ImageLoaded(response.bodyBytes));
      } else {
        emit(const ImageError('Failed to load image'));
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
      final dir = await getApplicationDocumentsDirectory();
      var nameByDateTime =
          'SavedImage_${DateFormat('yyyy_MM_dd__HH_mm_ss').format(DateTime.now())}';
      var filename = '${dir.path}/$nameByDateTime.png';
      final file = File(filename);
      await file.writeAsBytes(event.imageBytes);
      if (await SharedPreferencesService.setFilePath(
          nameByDateTime, filename)) {
        emit(ImageSaved());
      } else {
        emit(const ImageError('Error while saving the image'));
      }
    } catch (e) {
      emit(ImageError(e.toString()));
    }
  }

  Future<void> _onErrorDismissed(
      ErrorDismissedEvent event, Emitter<ImageState> emit) async {
    emit(ImageInitial());
  }
}
