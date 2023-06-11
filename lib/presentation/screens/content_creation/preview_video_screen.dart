import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:librino/presentation/widgets/shared/inkwell_widget.dart';
import 'package:librino/presentation/widgets/shared/librino_scaffold.dart';
import 'package:librino/presentation/widgets/shared/video_player_widget.dart';

class PreviewVideoScreen extends StatelessWidget {
  final XFile video;

  const PreviewVideoScreen(this.video, {super.key});

  @override
  Widget build(BuildContext context) {
    return LibrinoScaffold(
      floatingActionButton: Tooltip(
        message: 'Confirmar vídeo',
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: Container(
            margin: EdgeInsets.only(left: 2.5),
            child: Icon(Icons.send),
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Tooltip(
                message: 'Fechar',
                child: InkWellWidget(
                  borderRadius: 50,
                  onTap: () => Navigator.pop(context),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.close,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: VideoPlayerWidget(
              videoPath: video.path,
              isFromNetwork: false,
            ),
          )
        ],
      ),
    );
  }
}
