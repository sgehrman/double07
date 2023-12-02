import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:double07/src/animations/anima_utils.dart';
import 'package:double07/src/animations/animation_specs/letter_animations.dart';
import 'package:double07/src/animations/text/letter_painter.dart';
import 'package:flutter/material.dart';

class AnimatedLetter {
  AnimatedLetter({
    required this.letter,
    required this.image,
    required this.wordSize,
    required this.letterAlignment,
    required this.letterSize,
  });

  final String letter;
  final Size wordSize;
  final Size letterSize;
  final ui.Image image;
  final Alignment letterAlignment;

  static void paintLetters({
    required Canvas canvas,
    required Size size,
    required List<AnimatedLetter> letters,
    required List<LetterAnimations> letterAnimations,
  }) {
    // final nextColor = NextColor();

    for (int i = 0; i < letters.length; i++) {
      letters[i].paint(
        canvas: canvas,
        size: size,
        letterAnimations: letterAnimations[i],
        // backgroundColor: nextColor.darkColor(),
      );
    }
  }

  void paint({
    required Canvas canvas,
    required Size size,
    required LetterAnimations letterAnimations,
    Color? backgroundColor,
  }) {
    if (letterAnimations.isRunning) {
      final alignment = letterAnimations.alignment.value;

      final rect = Offset.zero & size;

      Rect destRect = alignment.inscribe(
        Size(
          wordSize.width,
          wordSize.height,
        ),
        rect,
      );

      // not working? white is on top
      // canvas.drawRect(destRect, Paint()..color = Colors.white);

      destRect = letterAlignment.inscribe(
        Size(
          letterSize.width,
          letterSize.height,
        ),
        destRect,
      );

      if (backgroundColor != null) {
        canvas.drawRect(destRect, Paint()..color = backgroundColor);
      }

      canvas.save();

      final matrix = AnimaUtils.scaledRect(
        destRect,
        letterAnimations.scale.value,
      );

      canvas.transform(matrix.storage);

      paintImage(
        canvas: canvas,
        rect: destRect,
        image: image,
        fit: BoxFit.fill,
        opacity: letterAnimations.opacity.value,
        isAntiAlias: true,
        filterQuality: FilterQuality.high,
      );

      canvas.restore();
    }
  }

  static Future<List<AnimatedLetter>> createTextImages(
    String text,
    TextStyle style,
    double letterSpacing,
  ) async {
    final List<AnimatedLetter> result = [];

    final letterPainters = _createTextPainters(text, style);

    double wordWidth = 0;
    double wordHeight = 0;

    for (final letterPainter in letterPainters) {
      wordWidth += letterPainter.size.width;
      if (!letterPainter.isSpace) {
        wordWidth += letterSpacing;
      }

      wordHeight = math.max(wordHeight, letterPainter.size.height);
    }

    final wordRect = Offset.zero & Size(wordWidth, wordHeight);

    double nextX = 0;

    for (final letterPainter in letterPainters) {
      if (letterPainter.isSpace) {
        nextX += letterPainter.size.width;
      } else {
        final alignment = AnimaUtils.makeAlignment(
          nextX,
          0,
          letterPainter.size,
          wordRect,
        );

        nextX += letterPainter.size.width + letterSpacing;

        result.add(
          AnimatedLetter(
            letter: letterPainter.letter,
            image: await letterPainter.image(),
            letterSize: letterPainter.size,
            wordSize: Size(wordWidth, wordHeight),
            letterAlignment: alignment,
          ),
        );
      }
    }

    return result;
  }

  // ====================================================
  // private methods

  static List<LetterPainter> _createTextPainters(
    String text,
    TextStyle style,
  ) {
    final List<LetterPainter> result = [];

    for (final s in text.characters) {
      result.add(LetterPainterCache().get(s, style));
    }

    return result;
  }
}
