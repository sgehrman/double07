import 'package:double07/src/animations/text/anima_text_animations.dart';
import 'package:double07/src/animations/text/anima_text_state.dart';
import 'package:flutter/material.dart';

class AnimaText {
  AnimaText(this.state);

  final AnimaTextState state;
  late final AnimaTextAnimations _animations;

  Future<void> initialize({
    required AnimationController controller,
  }) async {
    _animations = AnimaTextAnimations(state);

    await _animations.initialize(controller: controller);
  }

  void paint({
    required Canvas canvas,
    required Size size,
  }) {
    _animations.paint(
      canvas: canvas,
      size: size,
    );
  }
}
