import 'package:double07/src/animation_sequence/runnable_animation.dart';
import 'package:double07/src/animations/text/anima_text_state.dart';
import 'package:double07/src/animations/text/titles/anima_title_animations.dart';
import 'package:flutter/material.dart';

class AnimaTitleText extends RunableAnimation {
  AnimaTitleText(this.state);

  final AnimaTextState state;
  late final AnimaTitleAnimations _animations;

  @override
  Future<void> initialize(
    Animation<double> controller,
  ) async {
    _animations = AnimaTitleAnimations(state);

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
