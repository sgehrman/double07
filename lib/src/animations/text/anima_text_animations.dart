import 'package:double07/src/animations/animation_specs/animation_spec.dart';
import 'package:double07/src/animations/animation_specs/letter_animations.dart';
import 'package:double07/src/animations/common_animations.dart';
import 'package:double07/src/animations/text/anima_text_state.dart';
import 'package:double07/src/animations/text/animated_letter.dart';
import 'package:double07/src/constants.dart';
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

  Animatable<Alignment> _alignmentTween(
    double begin,
    SequenceWeights weights,
  ) {
    if (state.animationTypes.contains(TextAnimationType.alignment)) {
      return CommonAnimations.alignmentTween(
        begin: begin,
        end: 1, // 1 is end of parent animation
        alignments: state.alignments,
        inCurve: state.inCurve,
        outCurve: state.outCurve,
        weights: weights,
      );
    }

    return ConstantTween<Alignment>(
      state.alignments.first,
    );
  }

  Animatable<double> _opacityTween(
    double begin,
    SequenceWeights weights,
  ) {
    if (state.animationTypes.any(
      [TextAnimationType.opacity, TextAnimationType.fadeInOut].contains,
    )) {
      return CommonAnimations.inOutTween(
        begin: begin,
        end: 1, // 1 is end of parent animation
        beginValue: 0,
        endValue: state.opacity,
        inCurve: state.opacityCurve,
        outCurve: state.opacityCurve,
        weights: weights,
      );
    }

    return ConstantTween<double>(state.opacity);
  }

  Animatable<double> _scaleTween(
    double begin,
    double end,
  ) {
    if (state.animationTypes.contains(TextAnimationType.scale)) {
      return Tween<double>(begin: 3, end: 1).chain(
        CurveTween(
          curve: Interval(
            begin,
            end,
            curve: state.inCurve,
          ),
        ),
      );
    }

    return ConstantTween<double>(1);
  }

  List<LetterAnimations> _buildAnimations({
    required int count,
    required AnimationController controller,
  }) {
    final List<LetterAnimations> result = [];

    final parent = AnimationSpec.parentAnimation(
      controller: controller,
      begin: state.timing.start,
      end: state.timing.groupEnd,
    );

    // convert to 0..1
    final double ratio = 1 / state.timing.totalTime;
    double letterDuration = state.timing.animationTime / count;
    letterDuration *= ratio;

    for (int i = 0; i < count; i++) {
      final start = i * letterDuration;
      final end = start + letterDuration;

      final weights = AnimaTiming.group(
        start: start,
        end: end,
        groupEnd: 1,
      ).weights;

      // const weights = SequenceWeights.equal();
      // print('inde: $i');
      // print(weights);

      result.add(
        LetterAnimations(
          master: controller,
          parent: parent,
          scale: _scaleTween(start, end),
          alignment: _alignmentTween(start, weights),
          opacity: _opacityTween(start, weights),
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
