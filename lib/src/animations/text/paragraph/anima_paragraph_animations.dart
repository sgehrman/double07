import 'package:double07/src/animations/animation_specs/animation_spec.dart';
import 'package:double07/src/animations/animation_specs/letter_animations.dart';
import 'package:double07/src/animations/common_animations.dart';
import 'package:double07/src/animations/text/anima_text_state.dart';
import 'package:double07/src/animations/text/animated_letter.dart';
import 'package:double07/src/constants.dart';
import 'package:flutter/material.dart';

class AnimaParagraphAnimations {
  AnimaParagraphAnimations(this.state);

  late final List<AnimatedLetter> _textLetters;
  final List<LetterAnimations> _inAnimations = [];
  final List<LetterAnimations> _outAnimations = [];

  final AnimaTextState state;

  Future<void> initialize(
    Animation<double> controller,
  ) async {
    _textLetters = await AnimatedLetter.createLetters(
      state.text,
      _textStyle(),
      state.letterSpacing,
    );

    final driver = AnimationSpec.parentAnimation(
      parent: controller,
      begin: state.timingInfo.begin,
      end: state.timingInfo.end,
    );

    _buildAnimations(
      count: _textLetters.length,
      controller: controller,
      driver: driver,
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

  Animation<Alignment> _alignmentTween({
    required Animation<double> parent,
    required bool inMode,
    required double begin,
    required double end,
    required SequenceWeights weights,
  }) {
    if (state.animationTypes.contains(TextAnimationType.alignment)) {
      return CommonAnimations.alignmentAnima(
        parent: parent,
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
    ).animate(parent);
  }

  Animation<double> _opacityTween({
    required Animation<double> parent,
    required bool inMode,
    required double begin,
    required double end,
  }) {
    if (state.animationTypes.any(
      [TextAnimationType.opacity, TextAnimationType.fadeInOut].contains,
    )) {
      return CommonAnimations.basicAnima(
        parent: parent,
        begin: begin,
        end: end,
        beginValue: inMode ? 0 : state.opacity,
        endValue: inMode ? state.opacity : 0,
        curve: state.opacityCurve,
      );
    }

    return ConstantTween<double>(state.opacity).animate(parent);
  }

  Animation<double> _scaleTween({
    required Animation<double> parent,
    required bool inMode,
    required double begin,
    required double end,
  }) {
    if (state.animationTypes.contains(TextAnimationType.scale)) {
      final tween =
          Tween<double>(begin: inMode ? 6 : 1, end: inMode ? 1 : 6).chain(
        CurveTween(
          curve: state.inCurve,
        ),
      );

      return tween.animate(
        CurvedAnimation(
          parent: parent,
          curve: Interval(
            begin,
            end,
          ),
        ),
      );
    }

    return ConstantTween<double>(1).animate(parent);
  }

  void _buildAnimations({
    required int count,
    required Animation<double> controller,
    required Animation<double> driver,
  }) {
    final timing = AnimaTiming(
      numItems: state.timingInfo.numItems,
    );

    for (int i = 0; i < count; i++) {
      if (state.timingInfo.outMode) {
        _outAnimations.add(
          LetterAnimations(
            controllers: [controller],
            scale: ConstantTween<double>(1).animate(driver),
            alignment: _alignmentTween(
              parent: driver,
              inMode: false,
              begin: 0,
              end: 1,
              weights: const SequenceWeights.equal(),
            ),
            opacity: _opacityTween(
              parent: driver,
              inMode: false,
              begin: 0,
              end: 1,
            ),
          ),
        );
      } else {
        final begin = timing.beginForIndex(i);
        final end = timing.endForIndex(i);

        _inAnimations.add(
          LetterAnimations(
            controllers: [controller],
            scale: _scaleTween(
              parent: driver,
              inMode: true,
              begin: begin,
              end: end,
            ),
            alignment: _alignmentTween(
              parent: driver,
              inMode: true,
              begin: begin,
              end: end,
              weights: const SequenceWeights.equal(),
            ),
            opacity: _opacityTween(
              parent: driver,
              inMode: true,
              begin: begin,
              end: end,
            ),
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
