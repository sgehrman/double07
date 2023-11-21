import 'package:double07/src/animations/animated_letter.dart';
import 'package:double07/src/animations/animation_spec.dart';
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
  late final List<LetterAnimations> _letterAnimations;

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

  late final TweenSequence<double> _scaleSequence;

  Future<void> initialize({
    required AnimationController controller,
  }) async {
    _textLetters = await AnimatedLetter.createTextImages(
      text,
      _textStyle(),
      letterSpacing,
    );

    // expensve to create, do here
    _scaleSequence = TweenSequence<double>([
      TweenSequenceItem<double>(
        tween: ConstantTween<double>(1),
        weight: 1,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 15, end: 1).chain(
          CurveTween(
            curve: curve,
          ),
        ),
        weight: 1,
      ),
    ]);

    _letterAnimations = _buildAnimations(
      count: _textLetters.length,
      controller: controller,
      curve: curve,
      timeEnd: timeEnd,
      timeStart: timeStart,
      startAlignment: startAlignment,
      endAlignment: endAlignment,
      opacity: opacity,
      scaleSequence: _scaleSequence,
    );
  }

  void paint({
    required Canvas canvas,
    required Size size,
  }) {
    AnimatedLetter.paintLetters(
      canvas: canvas,
      size: size,
      letters: _textLetters,
      letterAnimations: _letterAnimations,
    );
  }

  // ============================================================
  // private methods
  // ============================================================

  static List<LetterAnimations> _buildAnimations({
    required int count,
    required AnimationController controller,
    required double timeStart,
    required double timeEnd,
    required Curve curve,
    required Alignment startAlignment,
    required Alignment endAlignment,
    required double opacity,
    required TweenSequence<double> scaleSequence,
  }) {
    final List<LetterAnimations> result = [];

    final time = timeEnd - timeStart;
    final double duration = time / count;
    const double overlap = 4;

    final masterParent =
        AnimationSpec.parentAnimation(controller, timeStart, timeEnd);

    for (int i = 0; i < count; i++) {
      final start = i * (duration / overlap);
      final end = start + (duration * overlap);

      final parent = AnimationSpec.parentAnimation(masterParent, start, 1);

      final alignmentAnima = AlignmentTween(
        begin: startAlignment,
        end: endAlignment,
      ).animate(
        CurvedAnimation(
          parent: parent,
          curve: Interval(
            start,
            end,
            curve: curve,
          ),
        ),
      );

      final opacityAnima = Tween<double>(
        begin: 0.1,
        end: opacity,
      ).animate(
        CurvedAnimation(
          parent: parent,
          curve: Interval(
            start,
            end,
            curve: curve,
          ),
        ),
      );

      final scaleAnima = scaleSequence.animate(
        CurvedAnimation(
          parent: parent,
          curve: Interval(
            start,
            end,
          ),
        ),
      );

      result.add(
        LetterAnimations(
          master: masterParent,
          parent: parent,
          alignment: alignmentAnima,
          opacity: opacityAnima,
          scale: scaleAnima,
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
