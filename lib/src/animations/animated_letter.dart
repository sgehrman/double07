import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:dfc_flutter/dfc_flutter_web.dart';
import 'package:double07/src/animations/animation_utils.dart';
import 'package:flutter/material.dart';

class AnimatedLetter {
  AnimatedLetter({
    required this.letter,
    required this.image,
    required this.wordSize,
    required this.alignment,
    required this.letterSize,
  });

  final String letter;
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
    required double opacity,
  }) {
    final nextColor = NextColor();

    for (int i = 0; i < letters.length; i++) {
      letters[i].paintLetter(
        canvas: canvas,
        size: size,
        textAnima: textAnimas[i],
        startAlignment: startAlignment,
        endAlignment: endAlignment,
        opacity: opacity,
        backgroundColor: nextColor.darkColor(),
      );
    }
  }

  void paintLetter({
    required Canvas canvas,
    required Size size,
    required Animation<double> textAnima,
    required Alignment startAlignment,
    required Alignment endAlignment,
    required double opacity,
    Color? backgroundColor,
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

      // not working? white is on top
      // canvas.drawRect(destRect, Paint()..color = Colors.white);

      destRect = alignment.inscribe(
        Size(
          letterSize.width,
          letterSize.height,
        ),
        destRect,
      );

      if (backgroundColor != null) {
        canvas.drawRect(destRect, Paint()..color = backgroundColor);
      }

      paintImage(
        canvas: canvas,
        rect: destRect,
        fit: BoxFit.fill,
        image: image,
        opacity: opacity,
        isAntiAlias: true,
        filterQuality: FilterQuality.high,
      );
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

    final half = wordWidth / 2;
    double nextX = 0;

    for (final letterPainter in letterPainters) {
      if (letterPainter.isSpace) {
        nextX += letterPainter.size.width;
      } else {
        double left;

        if (nextX > half) {
          // right side of half
          left = (nextX - half) / half;
        } else {
          // left side of half
          left = -1.0 + (nextX / half);
        }

        nextX += letterPainter.size.width + letterSpacing;

        result.add(
          AnimatedLetter(
            letter: letterPainter.letter,
            image: await _createTextImage(letterPainter),
            letterSize: letterPainter.size,
            wordSize: Size(wordWidth, wordHeight),
            alignment: Alignment(left, 0),
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
      return _LetterPainter(
        letter: char,
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
    this.textPainter,
  });

  String letter;
  TextPainter? textPainter;

  bool get isSpace => textPainter == null;

  Size get size {
    if (!isSpace) {
      return textPainter!.size;
    }

    // space
    return const Size(20, 20);
  }
}
