import 'package:flutter/material.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:librino/presentation/visual_alerts.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoPath;
  final double playbackSpeed;
  final int replaysNumber;
  final bool shouldLimitReplays;

  const VideoPlayerWidget({
    super.key,
    required this.videoPath,
    this.playbackSpeed = 1,
    this.replaysNumber = 3,
    this.shouldLimitReplays = false,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController playerCtrl;

  @override
  void initState() {
    super.initState();
    playerCtrl = VideoPlayerController.network(
      widget.videoPath,
      videoPlayerOptions: VideoPlayerOptions(
        mixWithOthers: true,
      ),
    );
    playerCtrl.addListener(() => setState(() {}));
    initializePlayer();
  }

  bool get shouldStartPlaying => !widget.shouldLimitReplays;

  Future<void> initializePlayer() async {
    await playerCtrl.initialize();
    await playerCtrl.setVolume(0);
    await playerCtrl.setLooping(false);
    await playerCtrl.setPlaybackSpeed(widget.playbackSpeed);
    if (shouldStartPlaying) {
      await playerCtrl.play();
    }
  }

  @override
  void dispose() {
    playerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: playerCtrl.value.aspectRatio,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          VideoPlayer(playerCtrl),
          _ControlsOverlay(
            controller: playerCtrl,
            replaysNumber: widget.replaysNumber,
            shouldLimitReplays: widget.shouldLimitReplays,
            isStartPlaying: shouldStartPlaying,
          ),
          VideoProgressIndicator(
            playerCtrl,
            allowScrubbing: false,
            colors: VideoProgressColors(
              playedColor: LibrinoColors.mainOrange,
            ),
          ),
        ],
      ),
    );
  }
}

class _ControlsOverlay extends StatefulWidget {
  final int replaysNumber;
  final bool shouldLimitReplays;
  final bool isStartPlaying;

  const _ControlsOverlay({
    Key? key,
    required this.controller,
    required this.replaysNumber,
    required this.shouldLimitReplays,
    required this.isStartPlaying,
  }) : super(key: key);

  final VideoPlayerController controller;

  @override
  State<_ControlsOverlay> createState() => _ControlsOverlayState();
}

class _ControlsOverlayState extends State<_ControlsOverlay> {
  var isStartPlaying = true;
  late int replaysNumber;

  @override
  void initState() {
    super.initState();
    isStartPlaying = widget.isStartPlaying;
    replaysNumber = widget.replaysNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          reverseDuration: const Duration(milliseconds: 200),
          child: widget.controller.value.isPlaying
              ? const SizedBox.shrink()
              : Container(
                  color: Colors.black26,
                  child: Center(
                    child: Icon(
                      isStartPlaying
                          ? Icons.replay
                          : replaysNumber == widget.replaysNumber
                              ? Icons.play_arrow
                              : Icons.replay,
                      color: Colors.white,
                      size: 100.0,
                      semanticLabel: 'Play',
                    ),
                  ),
                ),
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              if (widget.shouldLimitReplays && replaysNumber == 0) {
                VisualAlerts.showToast('Sem reproduções restantes');
                return;
              }
              if (!widget.controller.value.isPlaying) {
                widget.controller.play();
                setState(() {
                  replaysNumber = replaysNumber == 0 ? 0 : replaysNumber - 1;
                });
              }
            },
          ),
        ),
        if (widget.shouldLimitReplays)
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              color: Colors.black.withOpacity(0.5),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Reproduções restantes: ',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10.5,
                    ),
                  ),
                  Text(
                    replaysNumber.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
