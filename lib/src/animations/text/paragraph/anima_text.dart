import 'package:double07/src/animation_sequence/animation_sequence.dart';
import 'package:double07/src/animations/text/anima_text_state.dart';
import 'package:double07/src/animations/text/paragraph/anima_text_animations.dart';
import 'package:flutter/material.dart';

class AnimaText extends RunableAnimation {
  AnimaText(this.state);

  final AnimaTextState state;
  late final AnimaTextAnimations _animations;

  @override
  Future<void> initialize(
    Animation<double> controller,
  ) async {
    _animations = AnimaTextAnimations(state);

    await _animations.initialize(
      controller,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    _animations.paint(
      canvas: canvas,
      size: size,
    );
  }
}
