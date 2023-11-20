import 'package:double07/src/animations/animation_text_state.dart';
import 'package:flutter/material.dart';

class AnimationParagraphState {
  AnimationParagraphState({
    required this.lines,
    required this.alignment,
    required this.timeStart,
    required this.timeEnd,
    this.curve = Curves.elasticInOut,
  });

  final List<String> lines;
  final Alignment alignment;
  final double timeStart;
  final double timeEnd;
  final Curve curve;

  late final List<AnimationTextState> _animations;

  Future<void> initialize({
    required AnimationController controller,
  }) async {
    _animations = [];

    int index = 0;
    for (final line in lines) {
      _animations.add(
        AnimationTextState(
          text: line,
          fontSize: 44,
          color: Colors.white,
          startAlignment: Alignment(alignment.x, -3),
          endAlignment: Alignment(alignment.x, alignment.y + (index * 0.1)),
          timeStart: timeStart,
          timeEnd: timeEnd,
        ),
      );

      index++;
    }

    for (final l in _animations) {
      await l.initialize(controller: controller);
    }
  }

  void paint({
    required Canvas canvas,
    required Size size,
  }) {
    for (final animation in _animations) {
      animation.paint(canvas: canvas, size: size);
    }
  }
}
