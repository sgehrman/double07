import 'package:double07/src/animation_state.dart';
import 'package:double07/src/animations/backgrounds/anima_background_state.dart';
import 'package:flutter/material.dart';

class AnimaBackground implements RunableAnimation {
  AnimaBackground(this.state);

  final AnimaBackgroundState state;

  @override
  Future<void> initialize(AnimationController controller) async {
    await state.initialize(controller);
  }

  @override
  void paint(Canvas canvas, Size size) {
    state.paint(
      canvas,
      size,
    );
  }
}
