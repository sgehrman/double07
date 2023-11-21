import 'package:double07/src/animations/animated_text.dart';
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

  late final List<AnimatedText> _animations;

  Future<void> initialize({
    required AnimationController controller,
  }) async {
    _animations = [];

    final timePerLine = (timeEnd - timeStart) / lines.length;
    const overlap = 2;

    int index = 0;
    for (final line in lines) {
      final start = timeStart + (index * (timePerLine / overlap));

      _animations.add(
        AnimatedText(
          AnimationTextState(
            text: line,
            fontSize: 44,
            color: Colors.white,
            startAlignment: Alignment(alignment.x, -2),
            endAlignment: Alignment(alignment.x, alignment.y + (index * 0.1)),
            timeStart: start,
            timeEnd: start + (timePerLine * overlap),
            curve: Curves.easeInOut,
            // animationTypes: const {
            //   TextAnimationType.alignment,
            //   // TextAnimationType.scale,
            //   // TextAnimationType.opacity,
            // },
          ),
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
