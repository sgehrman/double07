import 'package:double07/src/animation_sequence/animation_sequence.dart';
import 'package:double07/src/animations/backgrounds/anima_background_animations.dart';
import 'package:double07/src/animations/backgrounds/anima_background_state.dart';
import 'package:flutter/material.dart';

class AnimaBackground extends RunableAnimation {
  AnimaBackground(this.state);

  final AnimaBackgroundState state;
  late final AnimaBackgroundAnimations _animations;

  @override
  Future<void> initialize(
    Animation<double> controller,
  ) async {
    _animations = AnimaBackgroundAnimations(state);

    await _animations.initialize(controller);
  }

  @override
  void paint(Canvas canvas, Size size) {
    _animations.paint(
      canvas,
      size,
    );
  }
}
