import 'package:double07/src/animation_sequence/animation_sequence.dart';
import 'package:double07/src/animations/anima_image/anima_image_animations.dart';
import 'package:double07/src/animations/anima_image/anima_image_state.dart';
import 'package:flutter/material.dart';

class AnimaImage extends RunableAnimation {
  AnimaImage(this.state);

  final AnimaImageState state;
  late final AnimaImageAnimations _animations;

  @override
  Future<void> initialize(AnimationController controller) async {
    _animations = AnimaImageAnimations(state);

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
