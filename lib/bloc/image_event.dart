part of 'image_bloc.dart';

abstract class ImageEvent extends Equatable {
  const ImageEvent();

  @override
  List<Object> get props => [];
}

class LoadImageEvent extends ImageEvent {
  final String imageUrl;

  const LoadImageEvent(this.imageUrl);

  @override
  List<Object> get props => [imageUrl];
}

class ProcessImageEvent extends ImageEvent {
  final Uint8List imageBytes;

  const ProcessImageEvent(this.imageBytes);

  @override
  List<Object> get props => [imageBytes];
}

class SaveImageEvent extends ImageEvent {
  final Uint8List imageBytes;

  const SaveImageEvent(this.imageBytes);

  @override
  List<Object> get props => [imageBytes];
}

class ErrorDismissedEvent extends ImageEvent {

  const ErrorDismissedEvent();

  @override
  List<Object> get props => [];
}