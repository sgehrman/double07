// ignore_for_file: avoid_web_libraries_in_flutter, unsafe_html

import 'dart:async';

import 'package:web/web.dart' as web;

mixin AudioPlayerMixin {
  StreamSubscription<dynamic>? _onEndListener;
  StreamSubscription<dynamic>? _onCanPlayListener;
  web.HTMLAudioElement? _audioElement;

  void platformDispose() {
    platformPause();

    _onEndListener?.cancel();
    _onCanPlayListener?.cancel();

    _audioElement?.remove();
  }

  void platformPlay() {
    if (_audioElement != null) {
      _audioElement?.play();
    }
  }

  void platformPause() {
    if (_audioElement != null) {
      _audioElement?.pause();
    }
  }

  void platformOpen({
    required String path,
  }) {
    _audioElement = web.HTMLAudioElement();
    _audioElement?.src = path;
    _audioElement?.loop = true;

    _onEndListener = _audioElement?.onEnded.listen((event) {
      print('end');
    });

    _onCanPlayListener = _audioElement?.onCanPlay.listen((event) {
      platformPlay();
    });
  }
}
