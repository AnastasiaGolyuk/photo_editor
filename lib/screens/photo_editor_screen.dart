import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_editor/bloc/image_bloc.dart';
import 'package:photo_editor/widgets/image_loading_widget.dart';
import 'package:photo_editor/widgets/image_processing_button_widget.dart';
import 'package:photo_editor/widgets/image_save_button_widget.dart';
import 'package:photo_editor/widgets/image_url_input_widget.dart';

import '../widgets/error_dialog_widget.dart';
import '../widgets/image_display_widget.dart';

class PhotoEditorScreen extends StatelessWidget {
  const PhotoEditorScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ImageBloc(),
      child: BlocBuilder<ImageBloc, ImageState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(title),
            ),
            body: Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    if (state is ImageInitial || state is ImageSaved)
                      const ImageUrlInputWidget(),
                    if (state is ImageLoading)
                      const ImageLoadingWidget(
                        message: 'Loading image from given URL...',
                      ),
                    if (state is ImageLoaded || state is ImageProcessed)
                      ImageDisplayWidget(
                          imageBytes: (state is ImageLoaded)
                              ? state.imageBytes
                              : (state as ImageProcessed).imageBytes),
                    if (state is ImageLoaded)
                      ImageProcessingWidget(imageBytes: state.imageBytes),
                    if (state is ImageProcessing)
                      const ImageLoadingWidget(message: 'Processing image...'),
                    if (state is ImageProcessed)
                      ImageSaveButtonWidget(imageBytes: state.imageBytes),
                    if (state is ImageError)
                      ErrorDialogWidget(message: state.message),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
