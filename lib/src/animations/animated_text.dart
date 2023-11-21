import 'package:double07/src/animations/animation_text_state.dart';
import 'package:flutter/material.dart';

class AnimatedText {
  AnimatedText(this.state);

  final AnimationTextState state;

  Future<void> initialize({
    required AnimationController controller,
  }) async {
    await state.initialize(controller: controller);
  }

  void paint({
    required Canvas canvas,
    required Size size,
  }) {
    state.paint(canvas: canvas, size: size);
  }
}
