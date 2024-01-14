import 'dart:ui' as ui;

import 'package:double07/src/animations/anima_utils.dart';
import 'package:flutter/material.dart';

class LetterPainter {
  LetterPainter({
    required this.letter,
    required this.style,
    required this.imageScale,
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
  final int imageScale;
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
      print(
        'LetterPainter zero size - "$letter", codeUnits: ${letter.codeUnits}, isSpace: $isSpace, $style',
      );

      result = const Size(10, 10);
    }

    return result;
  }

  Future<ui.Image> image() async {
    if (_image == null) {
      final destRect = Rect.fromLTWH(
        0,
        0,
        size.width * imageScale, // larger to avoid pixelation
        size.height * imageScale,
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

  LetterPainter get({
    required String letter,
    required TextStyle style,
    required int imageScale,
  }) {
    final String key = '$letter:$style:$imageScale';

    final found = _cache[key];
    if (found == null) {
      _cache[key] = LetterPainter(
        letter: letter,
        style: style,
        imageScale: imageScale,
      );
    }

    return _cache[key]!;
  }

  // free up memory
  void clear() {
    _cache.clear();
  }
}
