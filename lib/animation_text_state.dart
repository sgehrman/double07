import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:double07/animated_text_info.dart';
import 'package:double07/animation_utils.dart';
import 'package:flutter/material.dart';

class AnimationTextState {
  AnimationTextState({
    required this.text,
    required this.fontSize,
    required this.color,
    required this.startAlignment,
    required this.endAlignment,
    required this.timeStart,
    required this.timeEnd,
  });

  final List<AnimatedTextInfo> textImages = [];
  late final List<Animation<double>> textAnimations;

  final String text;
  final double fontSize;
  final Color color;
  final Alignment startAlignment;
  final Alignment endAlignment;
  final double timeStart;
  final double timeEnd;

  Future<void> initialize({
    required AnimationController controller,
  }) async {
    await _createTextImages();

    textAnimations = _buildTextAnimations(
      controller: controller,
      text: text,
      tStart: timeStart,
      tEnd: timeEnd,
    );
  }

  static List<Animation<double>> _buildTextAnimations({
    required AnimationController controller,
    required String text,
    required double tStart,
    required double tEnd,
  }) {
    final List<Animation<double>> result = [];

    final len = text.length;

    final time = tEnd - tStart;
    double duration = time / len;
    const compress = 0.05;

    final spacer = duration * compress;
    duration = duration + (duration - spacer);

    for (int i = 0; i < len; i++) {
      final start = tStart + (i * spacer);
      final end = start + duration;

      result.add(
        Tween<double>(
          begin: 0,
          end: 1,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              start,
              end,
              curve: Curves.elasticInOut,
            ),
          ),
        ),
      );
    }

    return result;
  }

  TextPainter _createTextPainter(String text) {
    final TextStyle style = TextStyle(
      color: color,
      fontSize: fontSize,
      height: 1,
    );

    final textPainter = TextPainter(
      text: TextSpan(
        style: style,
        text: text,
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
      imageSize.width * 3, // larger to avoid pixelation
      imageSize.height * 3,
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

  void paintText({
    required Canvas canvas,
    required Size size,
  }) {
    for (int i = 0; i < textImages.length; i++) {
      _paintText(
        canvas: canvas,
        size: size,
        textImage: textImages[i],
        textAnima: textAnimations[i],
      );
    }
  }

  void _paintText({
    required Canvas canvas,
    required Size size,
    required AnimatedTextInfo textImage,
    required Animation<double> textAnima,
  }) {
    if (textAnima.value > 0) {
      final rect = Offset.zero & size;

      final tSize = textImage.painter.size;

      final alignment = Alignment.lerp(
            startAlignment,
            endAlignment,
            textAnima.value,
          ) ??
          Alignment.center;

      Rect destRect = alignment.inscribe(
        Size(
          textImage.wordSize.width,
          textImage.wordSize.height,
        ),
        rect,
      );

      destRect = textImage.alignment.inscribe(
        Size(
          tSize.width,
          tSize.height,
        ),
        destRect,
      );

      paintImage(
        canvas: canvas,
        rect: destRect,
        fit: BoxFit.fill,
        image: textImage.image,
        opacity: 0.3,
        isAntiAlias: true,
        filterQuality: FilterQuality.high,
      );
    }
  }
}
