import 'package:double07/src/animations/animation_specs/animation_spec.dart';
import 'package:double07/src/animations/animation_specs/letter_animations.dart';
import 'package:double07/src/animations/common_animations.dart';
import 'package:double07/src/animations/text/anima_text_state.dart';
import 'package:double07/src/animations/text/animated_letter.dart';
import 'package:flutter/material.dart';

class AnimaTextAnimations {
  AnimaTextAnimations({
    required this.state,
    required this.onStatusChange,
  });

  late final List<AnimatedLetter> _textLetters;
  late final List<LetterAnimations> _letterAnimations;
  late final Animation<double> _parent;
  final AnimaTextState state;
  final void Function(AnimationStatus event) onStatusChange;

  Future<void> initialize({
    required AnimationController controller,
  }) async {
    _textLetters = await AnimatedLetter.createTextImages(
      state.text,
      _textStyle(),
      state.letterSpacing,
    );

    _parent = AnimationSpec.parentAnimation(
      controller: controller,
      begin: state.timingInfo.begin,
      end: state.timingInfo.parentEnd,
    );

    _parent.addStatusListener(_statusListener);

    _letterAnimations = _buildAnimations(
      count: _textLetters.length,
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

  void dispose() {
    _parent.removeStatusListener(_statusListener);
  }

  // ============================================================
  // private methods
  // ============================================================

  void _statusListener(AnimationStatus status) {
    switch (status) {
      case AnimationStatus.dismissed:
      case AnimationStatus.forward:
      case AnimationStatus.reverse:
        break;
      case AnimationStatus.completed:
        onStatusChange(status);

        _letterAnimations.clear();
        _letterAnimations.addAll(
          _buildFadeOutAnimations(
            count: _textLetters.length,
          ),
        );
        break;
    }
  }

  Animatable<Alignment> _alignmentTween(
    double begin,
    double end,
  ) {
    if (state.animationTypes.contains(TextAnimationType.alignment)) {
      return CommonAnimations.alignmentTween(
        begin: begin,
        end: end,
        alignments: state.alignments,
        curve: state.inCurve,
      );
    }

    return ConstantTween<Alignment>(
      state.alignments.first,
    );
  }

  Animatable<double> _opacityTween(
    bool inTween,
    double begin,
    double end,
  ) {
    if (state.animationTypes.any(
      [TextAnimationType.opacity, TextAnimationType.fadeInOut].contains,
    )) {
      return CommonAnimations.inOutTween(
        begin: begin,
        end: end,
        beginValue: inTween ? 0 : state.opacity,
        endValue: inTween ? state.opacity : 0,
        curve: state.opacityCurve,
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
  }) {
    final List<LetterAnimations> result = [];

    // convert to 0..1
    final timing = AnimaTiming(
      info: state.timingInfo,
    );

    for (int i = 0; i < count; i++) {
      final begin = timing.beginForIndex(i);
      final end = timing.endForIndex(i);

      result.add(
        LetterAnimations(
          master: _parent,
          parent: _parent,
          keepAlive: true,
          scale: _scaleTween(begin, end),
          alignment: _alignmentTween(begin, end),
          opacity: _opacityTween(true, begin, end),
        ),
      );
    }

    return result;
  }

  List<LetterAnimations> _buildFadeOutAnimations({
    required int count,
  }) {
    final List<LetterAnimations> result = [];

    // convert to 0..1
    final timing = AnimaTiming(
      info: state.timingInfo,
    );

    for (int i = 0; i < count; i++) {
      final begin = timing.beginForIndex(i);
      final end = timing.endForIndex(i);

      result.add(
        LetterAnimations(
          master: _parent,
          parent: _parent,
          keepAlive: true,
          scale: _scaleTween(begin, end),
          alignment: _alignmentTween(begin, end),
          opacity: _opacityTween(false, begin, end),
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
