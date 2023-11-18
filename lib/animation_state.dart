import 'dart:ui' as ui;

import 'package:dfc_flutter/dfc_flutter_web.dart';
import 'package:double07/animation_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnimationState {
  AnimationState();

  List<TextImageInfo> textImages = [];
  bool isInitialized = false;

  double ballValue = 0;
  double textAnimValue = 0;

  double fadeBallPosition = -1;
  double fadeBallOpacity = 0;

  double fadeBallPosition2 = -1;
  double fadeBallOpacity2 = 0;

  int lastV = -1;
  late ui.Image hendersonImage;

  // =================================================

  void reset() {
    // xxx
  }

  Future<void> initialize() async {
    if (!isInitialized) {
      // must set this first before async createTextImages
      isInitialized = true;

      final ByteData byteData =
          await rootBundle.load('assets/images/henderson.png');

      hendersonImage =
          await ImageProcessor.bytesToImage(byteData.buffer.asUint8List());

      await _createTextImages();
    }
  }

  TextPainter _createTextPainter(String text) {
    const TextStyle style = TextStyle(
      color: Colors.white,
      fontSize: 64,
      height: 1,
    );

    final TextSpan span12 = TextSpan(style: style, text: text.toUpperCase());
    final textPainter = TextPainter(
      text: span12,
      // textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    return textPainter;
  }

  List<TextPainter> _createTextPainters() {
    const word = 'Deckr';
    final List<TextPainter> result = [];

    for (final s in word.characters) {
      result.add(_createTextPainter(s));
    }

    return result;
  }

  Future<void> _createTextImages() async {
    final textPainters = _createTextPainters();

    double width = 0;
    for (final painter in textPainters) {
      width += painter.size.width;
    }

    for (final painter in textPainters) {
      textImages.add(
        TextImageInfo(
          image: await createTextImage(painter),
          painter: painter,
          offset: Offset(width / 2, 0),
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

  // =================================================

  void update(double value, double textValue) {
    ballValue = value;
    textAnimValue = textValue;

    updateBall();
  }

  void updateBall() {
    final int v = (ballValue * 100).round();

    if (v != lastV && (v % 15) == 0) {
      lastV = v;

      if (fadeBallPosition == -1) {
        fadeBallOpacity = 1;
        fadeBallPosition = ballValue;
      } else if (fadeBallPosition2 == -1) {
        fadeBallOpacity2 = 1;
        fadeBallPosition2 = ballValue;
      }
    }

    if (fadeBallPosition != -1) {
      fadeBallOpacity -= 0.015;

      if (fadeBallOpacity < 0) {
        fadeBallPosition = -1;
      }
    }

    if (fadeBallPosition2 != -1) {
      fadeBallOpacity2 -= 0.015;

      if (fadeBallOpacity2 < 0) {
        fadeBallPosition2 = -1;
      }
    }
  }
}

// =================================================

class TextImageInfo {
  TextImageInfo({
    required this.painter,
    required this.image,
    required this.offset,
  });

  final TextPainter painter;
  final Offset offset;
  final ui.Image image;
}
