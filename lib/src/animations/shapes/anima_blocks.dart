import 'package:double07/src/animation_sequence/animation_sequence.dart';
import 'package:double07/src/animations/shapes/anima_blocks_animations.dart';
import 'package:double07/src/animations/shapes/anima_blocks_state.dart';
import 'package:flutter/material.dart';

class AnimaBlocks extends RunableAnimation {
  AnimaBlocks(this.state);

  final AnimaBlocksState state;
  late final AnimaBlocksAnimations _animations;

  @override
  Future<void> initialize(
    Animation<double> controller,
  ) async {
    _animations = AnimaBlocksAnimations(state);

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
