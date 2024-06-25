part of 'image_bloc.dart';

/// Base class for image states.
///
/// All subclasses of [ImageState] must override the [props] getter to include
/// all instance variables that should be considered in equality comparisons.
abstract class ImageState extends Equatable {
  const ImageState();

  @override
  List<Object> get props => [];
}

/// [ImageInitial] - State representing the initial state of the image.
class ImageInitial extends ImageState {}

/// [ImageLoading] - State representing that an image is currently loading.
class ImageLoading extends ImageState {}

/// [ImageLoaded] - State representing that an image has been loaded successfully.
class ImageLoaded extends ImageState {

  final Uint8List imageBytes;


  const ImageLoaded(this.imageBytes);

  @override
  List<Object> get props => [imageBytes];
}

/// [ImageProcessing] - State representing that an image is currently processing.
class ImageProcessing extends ImageState {}

/// [ImageProcessed] - State representing that an image has been processed successfully.
class ImageProcessed extends ImageState {

  final Uint8List imageBytes;

  const ImageProcessed(this.imageBytes);

  @override
  List<Object> get props => [imageBytes];
}

/// [ImageError] - State representing that some error has occurred.
class ImageError extends ImageState {

  final String message;

  const ImageError(this.message);

  @override
  List<Object> get props => [message];
}

/// [ImageSaved] - State representing that an image has been saved successfully.
class ImageSaved extends ImageState {}
