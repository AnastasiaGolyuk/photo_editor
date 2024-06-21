part of 'image_bloc.dart';


abstract class ImageState extends Equatable {
  const ImageState();

  @override
  List<Object> get props => [];
}

class ImageInitial extends ImageState {}

class ImageLoading extends ImageState {}

class ImageLoaded extends ImageState {
  final Uint8List imageBytes;

  const ImageLoaded(this.imageBytes);

  @override
  List<Object> get props => [imageBytes];
}

class ImageProcessing extends ImageState {}

class ImageProcessed extends ImageState {
  final Uint8List imageBytes;

  const ImageProcessed(this.imageBytes);

  @override
  List<Object> get props => [imageBytes];
}

class ImageError extends ImageState {
  final String message;

  const ImageError(this.message);

  @override
  List<Object> get props => [message];
}

class ImageSaved extends ImageState {}
