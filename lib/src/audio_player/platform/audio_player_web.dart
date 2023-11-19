// ignore_for_file: avoid_web_libraries_in_flutter, unsafe_html

import 'dart:async';
import 'dart:html' as html;

mixin AudioPlayerMixin {
  StreamSubscription<dynamic>? _onEndListener;
  StreamSubscription<dynamic>? _onCanPlayListener;
  html.AudioElement? _audioElement;

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
    _audioElement = html.AudioElement(path);
    _audioElement?.loop = true;

    _onEndListener = _audioElement?.onEnded.listen((event) {
      print('end');
    });

    _onCanPlayListener = _audioElement?.onCanPlay.listen((event) {
      platformPlay();
    });
  }
}
