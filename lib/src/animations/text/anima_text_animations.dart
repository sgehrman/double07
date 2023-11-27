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

    final parent = AnimationSpec.parentAnimation(
      parent: controller,
      begin: state.timingInfo.begin,
      end: state.timingInfo.end,
    );

    _buildAnimations(
      count: _textLetters.length,
      controller: controller,
      parent: parent,
    );
  }

  void paint({
    required Canvas canvas,
    required Size size,
  }) {
    if (state.timingInfo.outMode) {
      AnimatedLetter.paintLetters(
        canvas: canvas,
        size: size,
        letters: _textLetters,
        letterAnimations: _outAnimations,
      );
    } else {
      AnimatedLetter.paintLetters(
        canvas: canvas,
        size: size,
        letters: _textLetters,
        letterAnimations: _inAnimations,
      );
    }
  }

  // ============================================================
  // private methods
  // ============================================================

  Animatable<Alignment> _alignmentTween(
    bool inMode,
    double begin,
    double end,
    SequenceWeights weights,
  ) {
    if (state.animationTypes.contains(TextAnimationType.alignment)) {
      return CommonAnimations.alignmentTween(
        begin: begin,
        end: end,
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
    bool inMode,
    double begin,
    double end,
  ) {
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
    required Animation<double> parent,
  }) {
    final timing = AnimaTiming(
      numItems: state.timingInfo.numItems,
    );

    for (int i = 0; i < count; i++) {
      if (state.timingInfo.outMode) {
        _outAnimations.add(
          LetterAnimations(
            controllers: [controller],
            driver: parent,
            scale: ConstantTween<double>(1),
            alignment: ConstantTween<Alignment>(
              state.alignments.first,
            ),
            opacity: _opacityTween(false, 0.5, 1),
          ),
        );
      } else {
        final begin = timing.beginForIndex(i);
        final end = timing.endForIndex(i, stretchFactor: 2);

        _inAnimations.add(
          LetterAnimations(
            controllers: [controller],
            driver: parent,
            scale: _scaleTween(true, begin, end),
            alignment: _alignmentTween(
              true,
              begin,
              end,
              const SequenceWeights.equal(),
            ),
            opacity: _opacityTween(true, begin, end),
          ),
        );
      }
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
