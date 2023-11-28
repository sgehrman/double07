import 'package:double07/src/animations/animation_specs/animation_spec.dart';
import 'package:double07/src/animations/animation_specs/letter_animations.dart';
import 'package:double07/src/animations/common_animations.dart';
import 'package:double07/src/animations/text/anima_text_state.dart';
import 'package:double07/src/animations/text/animated_letter.dart';
import 'package:double07/src/constants.dart';
import 'package:flutter/material.dart';

class AnimaTitleAnimations {
  AnimaTitleAnimations(this.state);

  late final List<AnimatedLetter> _textLetters;
  final List<LetterAnimations> _inAnimations = [];
  final List<LetterAnimations> _outAnimations = [];

  final AnimaTextState state;

  Future<void> initialize(
    Animation<double> controller,
  ) async {
    _textLetters = await AnimatedLetter.createTextImages(
      state.text,
      _textStyle(),
      state.letterSpacing,
    );

    _buildAnimations(
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
      letterAnimations: _inAnimations,
    );

    AnimatedLetter.paintLetters(
      canvas: canvas,
      size: size,
      letters: _textLetters,
      letterAnimations: _outAnimations,
    );
  }

  // ============================================================
  // private methods
  // ============================================================

  Animatable<Alignment> _alignmentTween({
    required bool inMode,
    required double begin,
    required double end,
    required SequenceWeights weights,
  }) {
    if (state.animationTypes.contains(TextAnimationType.alignment)) {
      return CommonAnimations.alignmentTween(
        begin: begin,
        end: end,
        alignments: inMode ? state.alignments : state.alignments.reverse(),
        inCurve: state.inCurve,
        outCurve: state.outCurve,
        weights: weights,
      );
    }

    return ConstantTween<Alignment>(
      state.alignments.alignment,
    );
  }

  Animatable<double> _opacityTween({
    required bool inMode,
    required double begin,
    required double end,
  }) {
    if (state.animationTypes.any(
      [TextAnimationType.opacity, TextAnimationType.fadeInOut].contains,
    )) {
      return CommonAnimations.simpleTween(
        begin: begin,
        end: end,
        beginValue: inMode ? 0 : state.opacity,
        endValue: inMode ? state.opacity : 0,
        curve: state.opacityCurve,
      );
    }

    return ConstantTween<double>(state.opacity);
  }

  Animatable<double> _scaleTween(
    bool inMode,
    double begin,
    double end,
  ) {
    if (state.animationTypes.contains(TextAnimationType.scale)) {
      return Tween<double>(begin: inMode ? 6 : 1, end: inMode ? 1 : 6).chain(
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

  void _buildAnimations({
    required int count,
    required Animation<double> controller,
  }) {
    final timing = AnimaTiming(
      numItems: state.timingInfo.numItems,
    );

    final driver = AnimationSpec.parentAnimation(
      parent: controller,
      begin: 0,
      end: 0.5,
    );

    for (int i = 0; i < count; i++) {
      final begin = timing.beginForIndex(i);
      final end = timing.endForIndex(i);

      _inAnimations.add(
        LetterAnimations(
          controllers: [driver],
          driver: driver,
          scale: _scaleTween(true, begin, end),
          alignment: _alignmentTween(
            inMode: true,
            begin: begin,
            end: end,
            weights: const SequenceWeights.equal(),
          ),
          opacity: _opacityTween(
            inMode: true,
            begin: begin,
            end: end,
          ),
        ),
      );
    }

    final driver2 = AnimationSpec.parentAnimation(
      parent: controller,
      begin: 0.5,
      end: 1,
    );

    for (int i = 0; i < count; i++) {
      _outAnimations.add(
        LetterAnimations(
          controllers: [driver2],
          driver: driver2,
          scale: ConstantTween<double>(1),
          alignment: ConstantTween<Alignment>(
            state.alignments.alignment,
          ),
          opacity: _opacityTween(
            inMode: false,
            begin: 0,
            end: 1,
          ),
        ),
      );
    }
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
