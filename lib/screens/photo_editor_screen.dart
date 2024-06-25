import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_editor/bloc/image_bloc.dart';
import 'package:photo_editor/widgets/image_loading_widget.dart';
import 'package:photo_editor/widgets/image_processing_button_widget.dart';
import 'package:photo_editor/widgets/image_save_button_widget.dart';
import 'package:photo_editor/widgets/image_url_input_widget.dart';
import 'package:photo_editor/widgets/previous_images_grid_widget.dart';

import '../widgets/error_dialog_widget.dart';
import '../widgets/image_display_widget.dart';

/// Main widget that holds BlocProvider & BlocConsumer to create
/// [ImageBloc] instance, listen to state changes and show widgets,
/// based on current state.
class PhotoEditorScreen extends StatelessWidget {
  const PhotoEditorScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ImageBloc(),
      child: BlocConsumer<ImageBloc, ImageState>(
        listener: (context, state) async {
          if (state is ImageError) {
            await showDialog(
                context: context,
                builder: (BuildContext contextDialog) {
                  return ErrorDialogWidget(
                    message: state.message,
                    onClose: () {
                      BlocProvider.of<ImageBloc>(context)
                          .add(ErrorDismissedEvent());
                    },
                  );
                });
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(title),
            ),
            body: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                scrollDirection: Axis.vertical,
                child: (state is ImageInitial || state is ImageSaved)
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          ImageUrlInputWidget(),
                          SizedBox(
                            height: 20,
                          ),
                          PreviousImagesGridWidget(),
                        ],
                      )
                    : (state is ImageLoading)
                        ? const ImageLoadingWidget(
                            message: 'Loading image from given URL...',
                          )
                        : (state is ImageProcessing)
                            ? const ImageLoadingWidget(
                                message: 'Processing image...')
                            : (state is ImageLoaded || state is ImageProcessed)
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                        const SizedBox(
                                          height: 50,
                                        ),
                                        ImageDisplayWidget(
                                            imageBytes: (state is ImageLoaded)
                                                ? state.imageBytes
                                                : (state as ImageProcessed)
                                                    .imageBytes),
                                        (state is ImageLoaded)
                                            ? ImageProcessingButtonWidget(
                                                imageBytes: state.imageBytes)
                                            : ImageSaveButtonWidget(
                                                imageBytes:
                                                    (state as ImageProcessed)
                                                        .imageBytes)
                                      ])
                                : Container()),
          );
        },
      ),
    );
  }
}
