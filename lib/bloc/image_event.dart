part of 'image_bloc.dart';

/// Base class for image events.
///
/// All subclasses of [ImageEvent] must override the [props] getter to include
/// all instance variables that should be considered in equality comparisons.
abstract class ImageEvent extends Equatable {
  const ImageEvent();

  @override
  List<Object> get props => [];
}

/// [LoadImageEvent] - Event to load an image from a given URL.
class LoadImageEvent extends ImageEvent {
  final String imageUrl;

  const LoadImageEvent(this.imageUrl);

  @override
  List<Object> get props => [imageUrl];
}

/// [ProcessImageEvent] - Event to process an image with given image bytes.
class ProcessImageEvent extends ImageEvent {
  final Uint8List imageBytes;

  const ProcessImageEvent(this.imageBytes);

  @override
  List<Object> get props => [imageBytes];
}

/// [SaveImageEvent] - Event to save an image with given image bytes.
class SaveImageEvent extends ImageEvent {
  final Uint8List imageBytes;

  const SaveImageEvent(this.imageBytes);

  @override
  List<Object> get props => [imageBytes];
}

/// [ErrorDismissedEvent] - Event to change the state after error occurs.
class ErrorDismissedEvent extends ImageEvent {}
