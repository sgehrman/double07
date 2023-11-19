import 'package:dfc_flutter/dfc_flutter_web.dart';
import 'package:double07/src/audio_player/platform/audio_player.dart';
import 'package:double07/src/utils.dart';
import 'package:flutter/material.dart';

class BackgroundAudioPlayer extends StatefulWidget {
  const BackgroundAudioPlayer({
    required this.autoplay,
  });

  final bool autoplay;

  @override
  State<BackgroundAudioPlayer> createState() => _BackgroundAudioPlayerState();
}

class _BackgroundAudioPlayerState extends State<BackgroundAudioPlayer>
    with AudioPlayerMixin {
  final _mp3Path = '$kAssets/audio/morse-tune.mp3';

  @override
  void initState() {
    super.initState();

    if (widget.autoplay) {
      Future.delayed(const Duration(milliseconds: 10), () {
        open(path: _mp3Path);
      });
    }
  }

  @override
  void dispose() {
    platformDispose();

    super.dispose();
  }

  void play() {
    platformPlay();
  }

  void pause() {
    platformPause();
  }

  void open({
    required String path,
  }) {
    platformOpen(path: path);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.autoplay) {
      return const SizedBox();
    }

    return DFIconButton(
      onPressed: () {
        Future.delayed(const Duration(milliseconds: 222), () {
          open(path: _mp3Path);
        });
      },
      icon: const Icon(Icons.music_note),
    );
  }
}
