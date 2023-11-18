import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:double07/animated_text_info.dart';
import 'package:double07/animation_utils.dart';
import 'package:flutter/material.dart';

class AnimationTextState {
  AnimationTextState({
    required this.text,
    required this.startAlignment,
    required this.endAlignment,
  });

  List<AnimatedTextInfo> textImages = [];
  List<Animation<double>> textAnimations = [];

  final String text;
  final Alignment startAlignment;
  final Alignment endAlignment;

  // =================================================

  Future<void> initialize() async {
    await _createTextImages();
  }

  TextPainter _createTextPainter(String text) {
    const TextStyle style = TextStyle(
      color: Colors.white,
      fontSize: 64,
      height: 1,
    );

    final textPainter = TextPainter(
      text: TextSpan(
        style: style,
        text: text.toUpperCase(),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    return textPainter;
  }

  List<TextPainter> _createTextPainters() {
    final List<TextPainter> result = [];

    for (final s in text.characters) {
      result.add(_createTextPainter(s));
    }

    return result;
  }

  Future<void> _createTextImages() async {
    final textPainters = _createTextPainters();

    const double space = 10;
    double wordWidth = 0;
    double wordHeight = 0;

    for (final painter in textPainters) {
      wordWidth += painter.size.width + space;
      wordHeight = math.max(wordHeight, painter.size.height);
    }

    final mid = wordWidth / 2;
    double w = 0;

    for (final painter in textPainters) {
      double left = -1 + w / mid;

      if (w > mid) {
        left = (w - mid) / mid;
      }

      w += painter.size.width + space;

      textImages.add(
        AnimatedTextInfo(
          image: await createTextImage(painter),
          painter: painter,
          wordSize: Size(wordWidth, wordHeight),
          alignment: Alignment(left, 0),
        ),
      );
    }
  }

  Future<ui.Image> createTextImage(TextPainter textPainter) {
    final imageSize = textPainter.size;
    final destRect = Rect.fromLTWH(
      0,
      0,
      imageSize.width * 10, // larger to avoid pixelation
      imageSize.height * 10,
    );

    final matrix = AnimaUtils.sizeToRect(imageSize, destRect);

    final recorder = ui.PictureRecorder();
    final ui.Canvas canvas = ui.Canvas(recorder);

    canvas.drawRect(destRect, Paint()..color = Colors.transparent);

    canvas.transform(matrix.storage);

    textPainter.paint(
      canvas,
      Offset.zero,
    );

    final ui.Picture pict = recorder.endRecording();

    return pict.toImage(destRect.width.round(), destRect.height.round());
  }
}
