import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:dfc_flutter/dfc_flutter_web.dart';
import 'package:double07/animated_text_info.dart';
import 'package:double07/animation_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnimationState {
  AnimationState();

  bool isInitialized = false;

  // Deckr animation
  List<AnimatedTextInfo> textImages = [];
  List<Animation<double>> textAnimations = [];
  final textString = 'Deckr';

  // ball animation
  double ballValue = 0;
  double fadeBallPosition = -1;
  double fadeBallOpacity = 0;
  double fadeBallPosition2 = -1;
  double fadeBallOpacity2 = 0;
  int lastV = -1;

  // background
  late ui.Image hendersonImage;

  // =================================================

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

    for (final s in textString.characters) {
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

  // =================================================

  void update(double value, List<Animation<double>> textAnims) {
    ballValue = value;
    textAnimations = textAnims;

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
