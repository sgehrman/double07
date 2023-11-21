import 'package:double07/src/animations/animated_letter.dart';
import 'package:double07/src/animations/animation_spec.dart';
import 'package:flutter/material.dart';

enum TextAnimationType {
  alignment,
  scale,
  opacity,
}

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
    this.animationTypes = const {
      TextAnimationType.alignment,
      TextAnimationType.scale,
      TextAnimationType.opacity,
    },
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
  final Set<TextAnimationType> animationTypes;

  late final TweenSequence<double> _scaleSequence;
  late final TweenSequence<double> _opacitySequence;

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

    _opacitySequence = TweenSequence<double>(
      [
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0, end: opacity).chain(
            CurveTween(
              curve: curve,
            ),
          ),
          weight: 1,
        ),
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(opacity),
          weight: 4,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: opacity, end: 0).chain(
            CurveTween(
              curve: curve,
            ),
          ),
          weight: 3,
        ),
      ],
    );

    _letterAnimations = _buildAnimations(
      count: _textLetters.length,
      controller: controller,
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

  List<LetterAnimations> _buildAnimations({
    required int count,
    required AnimationController controller,
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

      final alignmentAnima =
          animationTypes.contains(TextAnimationType.alignment)
              ? AlignmentTween(
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
                )
              : AlignmentTween(begin: endAlignment, end: endAlignment)
                  .animate(parent);

      final opacityAnima = animationTypes.contains(TextAnimationType.opacity)
          ? _opacitySequence.animate(
              CurvedAnimation(
                parent: parent,
                curve: Interval(
                  start,
                  1,
                ),
              ),
            )
          : ConstantTween<double>(opacity).animate(parent);

      final scaleAnima = animationTypes.contains(TextAnimationType.scale)
          ? _scaleSequence.animate(
              CurvedAnimation(
                parent: parent,
                curve: Interval(
                  start,
                  end,
                ),
              ),
            )
          : ConstantTween<double>(1).animate(parent);

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
