import 'package:dfc_flutter/dfc_flutter_web.dart';
import 'package:double07/audio_player/platform/audio_player.dart';
import 'package:flutter/material.dart';

class SimpleMP3Player extends StatefulWidget {
  const SimpleMP3Player({super.key});

  @override
  State<SimpleMP3Player> createState() => _SimpleMP3PlayerState();
}

class _SimpleMP3PlayerState extends State<SimpleMP3Player>
    with AudioPlayerMixin {
  @override
  void initState() {
    super.initState();

    // Future.delayed(const Duration(milliseconds: 222), () {
    //   open(path: 'assets/assets/audio/morse-code-1.mp3');
    // });
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
    return DFIconButton(
      onPressed: () {
        Future.delayed(const Duration(milliseconds: 222), () {
          open(path: 'assets/assets/audio/morse-tune.mp3');
        });
      },
      icon: const Icon(Icons.music_note),
    );
  }
}
