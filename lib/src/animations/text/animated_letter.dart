import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:double07/src/animations/anima_utils.dart';
import 'package:double07/src/animations/animation_specs/letter_animations.dart';
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
    if (!letterAnimations.isRunning) {
      // print('not running letter');

      return;
    }

    final rect = Offset.zero & size;

    Rect destRect = letterAnimations.alignment.value.inscribe(
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
            image: await _createTextImage(letterPainter),
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

  static _LetterPainter _createTextPainter(String char, TextStyle style) {
    if (char == ' ') {
      return _LetterPainter.space(
        fontSize: style.fontSize ?? 20,
      );
    }

    final textPainter = TextPainter(
      text: TextSpan(
        style: style,
        text: char,
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    return _LetterPainter(
      textPainter: textPainter,
      letter: char,
    );
  }

  static List<_LetterPainter> _createTextPainters(
    String text,
    TextStyle style,
  ) {
    final List<_LetterPainter> result = [];

    for (final s in text.characters) {
      result.add(_createTextPainter(s, style));
    }

    return result;
  }

  static Future<ui.Image> _createTextImage(_LetterPainter letterPainter) {
    final imageSize = letterPainter.size;

    final destRect = Rect.fromLTWH(
      0,
      0,
      imageSize.width * 3, // larger to avoid pixelation
      imageSize.height * 3,
    );

    final matrix = AnimaUtils.sizeToRect(imageSize, destRect);

    final recorder = ui.PictureRecorder();
    final ui.Canvas canvas = ui.Canvas(recorder);

    canvas.transform(matrix.storage);

    if (!letterPainter.isSpace) {
      letterPainter.textPainter?.paint(
        canvas,
        Offset.zero,
      );
    } else {
      print('shouldnt get here, this is a space character');
    }

    final ui.Picture pict = recorder.endRecording();

    final result =
        pict.toImage(destRect.width.round(), destRect.height.round());

    pict.dispose();

    return result;
  }
}

// =======================================================

class _LetterPainter {
  _LetterPainter({
    required this.letter,
    required this.textPainter,
  });

  _LetterPainter.space({
    required this.fontSize,
  }) : letter = '';

  final String letter;
  TextPainter? textPainter;
  double fontSize = 0;

  bool get isSpace => textPainter == null;

  Size get size {
    if (!isSpace) {
      return textPainter!.size;
    }

    // space based on fontSize
    return Size(fontSize / 3, fontSize / 3);
  }
}
