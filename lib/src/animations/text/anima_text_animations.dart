import 'package:double07/src/animations/animation_specs/animation_spec.dart';
import 'package:double07/src/animations/animation_specs/letter_animations.dart';
import 'package:double07/src/animations/common_animations.dart';
import 'package:double07/src/animations/text/anima_text_state.dart';
import 'package:double07/src/animations/text/animated_letter.dart';
import 'package:flutter/material.dart';

class AnimaTextAnimations {
  AnimaTextAnimations(this.state);

  late final List<AnimatedLetter> _textLetters;
  late final List<LetterAnimations> _letterAnimations;

  final AnimaTextState state;

  Future<void> initialize({
    required AnimationController controller,
  }) async {
    _textLetters = await AnimatedLetter.createTextImages(
      state.text,
      _textStyle(),
      state.letterSpacing,
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

  Animation<Alignment> _alignmentAnima(
    double start,
    double end,
    Animation<double> parent,
  ) {
    if (state.animationTypes.contains(TextAnimationType.alignment)) {
      return CommonAnimations.alignmentAnima(
        start: start,
        end: end,
        alignments: state.alignments,
        parent: parent,
        inCurve: state.inCurve,
        outCurve: state.outCurve,
      );
    }

    return ConstantTween<Alignment>(
      state.alignments.first,
    ).animate(parent);
  }

  Animation<double> _opacityAnima(
    double start,
    double end,
    Animation<double> parent,
  ) {
    if (state.animationTypes.contains(TextAnimationType.opacity)) {
      return CommonAnimations.inOutAnima(
        start: start,
        end: 1, // 1 is end of parent animation
        beginValue: 0,
        endValue: state.opacity,
        parent: parent,
        inCurve: state.opacityCurve,
        outCurve: state.opacityCurve,
      );
    } else if (state.animationTypes.contains(TextAnimationType.fadeInOut)) {
      return CommonAnimations.inOutAnima(
        start: start,
        end: 1, // 1 is end of parent animation
        beginValue: 0,
        endValue: state.opacity,
        parent: parent,
        inCurve: state.opacityCurve,
        outCurve: state.opacityCurve,
      );
    }

    return ConstantTween<double>(state.opacity).animate(parent);
  }

  Animation<double> _scaleAnima(
    double start,
    double end,
    Animation<double> parent,
  ) {
    if (state.animationTypes.contains(TextAnimationType.scale)) {
      return Tween<double>(begin: 3, end: 1).animate(
        CurvedAnimation(
          parent: parent,
          curve: Interval(
            start,
            end,
            curve: state.inCurve,
          ),
        ),
      );
    }

    return ConstantTween<double>(1).animate(parent);
  }

  List<LetterAnimations> _buildAnimations({
    required int count,
    required AnimationController controller,
  }) {
    final List<LetterAnimations> result = [];
    final totalTime = state.timeEnd - state.timeStart;

    final masterParent = AnimationSpec.parentAnimation(
      controller,
      state.timeStart,
      state.timeEnd,
    );

    final double letterDuration = totalTime / count;

    for (int i = 0; i < count; i++) {
      final start = i * letterDuration;
      final end = start + letterDuration;

      final parent = AnimationSpec.parentAnimation(masterParent, start, 1);

      result.add(
        LetterAnimations(
          master: masterParent,
          parent: parent,
          alignment: _alignmentAnima(start, end, parent),
          opacity: _opacityAnima(start, end, parent),
          scale: _scaleAnima(start, end, parent),
        ),
      );
    }

    return result;
  }

  TextStyle _textStyle() {
    return TextStyle(
      color: state.color,
      fontSize: state.fontSize,
      fontWeight: state.bold ? FontWeight.bold : FontWeight.normal,
      height: 1,
    );
  }
}
