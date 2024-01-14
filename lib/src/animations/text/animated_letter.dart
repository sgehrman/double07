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
      letters[i].animatedPaint(
        canvas: canvas,
        size: size,
        letterAnimations: letterAnimations[i],
        // backgroundColor: nextColor.darkColor(),
      );
    }
  }

  void animatedPaint({
    required Canvas canvas,
    required Size size,
    required LetterAnimations letterAnimations,
    Color? backgroundColor,
  }) {
    if (letterAnimations.isRunning) {
      paint(
        canvas: canvas,
        size: size,
        alignment: letterAnimations.alignment.value,
        opacity: letterAnimations.opacity.value,
        scale: letterAnimations.scale.value,
      );
    }
  }

  void paint({
    required Canvas canvas,
    required Size size,
    required Alignment alignment,
    required double opacity,
    required double scale,
    Color? backgroundColor,
  }) {
    final rect = Offset.zero & size;

    Rect destRect = alignment.inscribe(
      Size(
        wordSize.width,
        wordSize.height,
      ),
      rect,
    );

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

    if (scale != 1) {
      canvas.save();

      final matrix = AnimaUtils.scaledRect(
        destRect,
        scale,
      );

      canvas.transform(matrix.storage);
    }

    paintImage(
      canvas: canvas,
      rect: destRect,
      image: image,
      fit: BoxFit.fill,
      opacity: opacity,
      isAntiAlias: true,
      filterQuality: FilterQuality.high,
    );

    if (scale != 1) {
      canvas.restore();
    }
  }

  static Future<List<AnimatedLetter>> createLetters({
    required String text,
    required TextStyle style,
    required double letterSpacing,
    required int imageScale,
  }) async {
    final List<AnimatedLetter> result = [];

    final letterPainters = _createTextPainters(
      text: text,
      style: style,
      imageScale: imageScale,
    );

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

  static Future<ui.Image> textImage({
    required String text,
    required TextStyle style,
    required double letterSpacing,
    required int imageScale,
  }) async {
    final letters = await createLetters(
      text: text,
      style: style,
      letterSpacing: letterSpacing,
      imageScale: imageScale,
    );

    // crashed with ZERO WIDTH SPACE. fixed below?
    Rect destRect = const Rect.fromLTWH(0, 0, 10, 10);
    if (letters.isNotEmpty) {
      destRect = Rect.fromLTWH(
        0,
        0,
        letters.first.wordSize.width,
        letters.first.wordSize.height,
      );
    }

    final recorder = ui.PictureRecorder();
    final ui.Canvas canvas = ui.Canvas(recorder);

    for (final letter in letters) {
      letter.paint(
        canvas: canvas,
        scale: 1,
        opacity: 1,
        alignment: Alignment.centerLeft,
        size: letter.wordSize,
      );
    }

    final ui.Picture pict = recorder.endRecording();

    final image =
        await pict.toImage(destRect.width.round(), destRect.height.round());

    pict.dispose();

    return image;
  }

  // ====================================================
  // private methods

  // Strings can have zero width spaces, remove those
  // Unicode Character 'ZERO WIDTH SPACE' (U+200B)
  // https://www.fileformat.info/info/unicode/char/200b/index.htm
  // codeUnits: [8203]
  static String cleanString(String input) {
    final codes = input.codeUnits;
    if (codes.contains(8203)) {
      final newCodes = codes.where((code) => code != 8203).toList();

      final cleaned = String.fromCharCodes(newCodes);

      print('Removed zero width spaces: $cleaned');

      return cleaned;
    }

    return input;
  }

  static List<LetterPainter> _createTextPainters({
    required String text,
    required TextStyle style,
    required int imageScale,
  }) {
    final List<LetterPainter> result = [];

    for (final s in cleanString(text).characters) {
      result.add(
        LetterPainterCache().get(
          letter: s,
          style: style,
          imageScale: imageScale,
        ),
      );
    }

    return result;
  }
}
