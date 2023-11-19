import 'package:double07/src/animations/animated_letter.dart';
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
    this.curve = Curves.elasticInOut,
    this.bold = false,
    this.letterSpacing = 10,
    this.opacity = 0.3,
  });

  late final List<AnimatedLetter> _textLetters;
  late final List<Animation<double>> _textAnimations;

  final String text;
  final double fontSize;
  final double opacity;
  final bool bold;
  final Color color;
  final Alignment startAlignment;
  final Alignment endAlignment;
  final double timeStart;
  final double timeEnd;
  final Curve curve;
  final double letterSpacing;

  Future<void> initialize({
    required AnimationController controller,
  }) async {
    _textLetters = await AnimatedLetter.createTextImages(
      text,
      _textStyle(),
      letterSpacing,
    );

    _textAnimations = _buildTextAnimations(
      controller: controller,
    );
  }

  void paint({
    required Canvas canvas,
    required Size size,
  }) {
    AnimatedLetter.paintWord(
      canvas: canvas,
      size: size,
      letters: _textLetters,
      textAnimas: _textAnimations,
      startAlignment: startAlignment,
      endAlignment: endAlignment,
      opacity: opacity,
    );
  }

  // ============================================================
  // private methods
  // ============================================================

  List<Animation<double>> _buildTextAnimations({
    required AnimationController controller,
  }) {
    final List<Animation<double>> result = [];

    final len = text.length;

    final time = timeEnd - timeStart;
    double duration = time / len;
    const compress = 0.05;

    final spacer = duration * compress;
    duration = duration + (duration - spacer);

    for (int i = 0; i < len; i++) {
      final start = timeStart + (i * spacer);
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
              curve: curve,
            ),
          ),
        ),
      );
    }

    return result;
  }

  TextStyle _textStyle() {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      height: 1,
    );
  }
}
