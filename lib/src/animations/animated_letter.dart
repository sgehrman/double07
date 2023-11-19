import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class AnimatedLetter {
  AnimatedLetter({
    required this.image,
    required this.wordSize,
    required this.alignment,
    required this.letterSize,
  });

  final Size wordSize;
  final Size letterSize;
  final ui.Image image;
  final Alignment alignment;

  static void paintWord({
    required Canvas canvas,
    required Size size,
    required List<AnimatedLetter> letters,
    required List<Animation<double>> textAnimas,
    required Alignment startAlignment,
    required Alignment endAlignment,
  }) {
    for (int i = 0; i < letters.length; i++) {
      letters[i].paintLetter(
        canvas: canvas,
        size: size,
        textAnima: textAnimas[i],
        startAlignment: startAlignment,
        endAlignment: endAlignment,
      );
    }
  }

  void paintLetter({
    required Canvas canvas,
    required Size size,
    required Animation<double> textAnima,
    required Alignment startAlignment,
    required Alignment endAlignment,
  }) {
    if (textAnima.value > 0) {
      final rect = Offset.zero & size;

      final lerpedAlignment = Alignment.lerp(
            startAlignment,
            endAlignment,
            textAnima.value,
          ) ??
          Alignment.center;

      Rect destRect = lerpedAlignment.inscribe(
        Size(
          wordSize.width,
          wordSize.height,
        ),
        rect,
      );

      destRect = alignment.inscribe(
        Size(
          letterSize.width,
          letterSize.height,
        ),
        destRect,
      );

      paintImage(
        canvas: canvas,
        rect: destRect,
        fit: BoxFit.fill,
        image: image,
        opacity: 0.3,
        isAntiAlias: true,
        filterQuality: FilterQuality.high,
      );
    }
  }
}
