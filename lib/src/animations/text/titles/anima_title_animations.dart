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
  }

  // ============================================================
  // private methods
  // ============================================================

  Animation<Alignment> _alignmentTween({
    required bool inMode,
    required Animation<double> parent,
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
    required double begin,
    required double end,
  }) {
    if (state.animationTypes.any(
      [TextAnimationType.opacity, TextAnimationType.fadeInOut].contains,
    )) {
      final opacity = TweenSequence<double>(
        <TweenSequenceItem<double>>[
          TweenSequenceItem(
            tween: Tween<double>(begin: 0, end: state.opacity).chain(
              CurveTween(
                curve: Interval(
                  begin,
                  end,
                ),
              ),
            ),
            weight: 1,
          ),
          TweenSequenceItem(
            tween: ConstantTween<double>(state.opacity),
            weight: 2,
          ),
          TweenSequenceItem(
            tween: Tween<double>(begin: state.opacity, end: 0),
            weight: 1,
          ),
        ],
      );

      return opacity.animate(parent);
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
  }) {
    final timing = AnimaTiming(
      numItems: state.timingInfo.numItems,
    );

    final master = AnimationSpec.parentAnimation(
      parent: controller,
      begin: state.timingInfo.begin,
      end: state.timingInfo.end,
    );

    for (int i = 0; i < count; i++) {
      final begin = timing.beginForIndex(i);
      // final end = timing.endForIndex(i);

      final parent = AnimationSpec.parentAnimation(
        parent: master,
        begin: begin,
        end: 1,
      );

      _inAnimations.add(
        LetterAnimations(
          controllers: [controller],
          scale: _scaleTween(
            parent: parent,
            inMode: true,
            begin: 0,
            end: 1,
          ),
          alignment: _alignmentTween(
            inMode: true,
            parent: parent,
            begin: 0,
            end: 1,
            weights: const SequenceWeights.equal(),
          ),
          opacity: _opacityTween(
            parent: controller,
            begin: begin,
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
