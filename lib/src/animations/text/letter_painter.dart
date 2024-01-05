import 'dart:ui' as ui;

import 'package:double07/src/animations/anima_utils.dart';
import 'package:flutter/material.dart';

class LetterPainter {
  LetterPainter({
    required this.letter,
    required this.style,
  }) {
    if (letter != ' ') {
      _textPainter = TextPainter(
        text: TextSpan(
          style: style,
          text: letter,
        ),
        textDirection: TextDirection.ltr,
      );

      _textPainter!.layout();
    }
  }

  final String letter;
  final TextStyle style;
  TextPainter? _textPainter;
  ui.Image? _image;

  bool get isSpace => _textPainter == null;

  Size get size {
    Size result;

    if (!isSpace) {
      result = _textPainter!.size;
    } else {
      final fontSize = style.fontSize ?? 20;

      // space based on fontSize
      result = Size(fontSize / 3, fontSize / 3);
    }

    // got a crash with "CanvasKitError: Cannot create surfaces of empty size"
    // not sure the cause yet, but avoid that
    if (result.width <= 0 || result.height <= 0) {
      print('BUG: letter_painter zero size - $letter, $isSpace, $style');

      result = const Size(10, 10);
    }

    return result;
  }

  Future<ui.Image> image() async {
    if (_image == null) {
      final destRect = Rect.fromLTWH(
        0,
        0,
        size.width * 3, // larger to avoid pixelation
        size.height * 3,
      );

      final matrix = AnimaUtils.sizeToRect(size, destRect);

      final recorder = ui.PictureRecorder();
      final ui.Canvas canvas = ui.Canvas(recorder);

      canvas.transform(matrix.storage);

      if (!isSpace) {
        _textPainter?.paint(
          canvas,
          Offset.zero,
        );
      } else {
        print('shouldnt get here, this is a space character');
      }

      final ui.Picture pict = recorder.endRecording();

      _image =
          await pict.toImage(destRect.width.round(), destRect.height.round());

      pict.dispose();
    }

    return _image!;
  }
}

// =============================================================

class LetterPainterCache {
  factory LetterPainterCache() {
    return _instance ??= LetterPainterCache._();
  }

  LetterPainterCache._();
  static LetterPainterCache? _instance;

  final Map<String, LetterPainter> _cache = {};

  LetterPainter get(
    String letter,
    TextStyle style,
  ) {
    final String key = '$letter:$style';

    final found = _cache[key];
    if (found == null) {
      _cache[key] = LetterPainter(letter: letter, style: style);
    }

    return _cache[key]!;
  }

  // free up memory
  void clear() {
    _cache.clear();
  }
}
