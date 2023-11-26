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
  bool _outMode = false;

  final AnimaTextState state;

  Future<void> initialize({
    required AnimationController controller,
  }) async {
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
    if (_outMode) {
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

  set outMode(bool mode) {
    _outMode = mode;
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
        alignments:
            inMode ? state.alignments : state.alignments.reversed.toList(),
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
      return Tween<double>(begin: inMode ? 3 : 1, end: inMode ? 1 : 3).chain(
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
    required AnimationController controller,
  }) {
    final parent = AnimationSpec.parentAnimation(
      controller: controller,
      begin: state.timingInfo.begin,
      end: state.timingInfo.end,
    );

    // convert to 0..1
    final timing = AnimaTiming(
      info: state.timingInfo,
    );

    for (int i = 0; i < count; i++) {
      final begin = timing.beginForIndex(i);
      final end = timing.endForIndex(i);

      _inAnimations.add(
        LetterAnimations(
          master: controller,
          parent: parent,
          scale: _scaleTween(true, begin, end),
          alignment:
              _alignmentTween(true, begin, end, const SequenceWeights.equal()),
          opacity: _opacityTween(true, begin, end),
        ),
      );

      _outAnimations.add(
        LetterAnimations(
          master: controller,
          parent: parent,
          scale: _scaleTween(false, begin, end),
          alignment:
              _alignmentTween(false, begin, end, const SequenceWeights.equal()),
          opacity: _opacityTween(false, begin, end),
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
