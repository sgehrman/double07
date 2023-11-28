import 'package:double07/src/animation_sequence/animation_sequence.dart';
import 'package:double07/src/animations/text/anima_text_state.dart';
import 'package:double07/src/animations/text/paragraph/anima_paragraph_animations.dart';
import 'package:flutter/material.dart';

class AnimaParagraphText extends RunableAnimation {
  AnimaParagraphText(this.state);

  final AnimaTextState state;
  late final AnimaParagraphAnimations _animations;

  @override
  Future<void> initialize(
    Animation<double> controller,
  ) async {
    _animations = AnimaParagraphAnimations(state);

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
