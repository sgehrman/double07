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

  late final List<AnimationTextState> _textAnimations;

  Future<void> initialize({
    required AnimationController controller,
  }) async {
    _textAnimations = [];

    int index = 0;
    for (final line in lines) {
      _textAnimations.add(
        AnimationTextState(
          text: line,
          fontSize: 44,
          color: Colors.white,
          startAlignment: Alignment(alignment.x, alignment.y + (index * 0.1)),
          endAlignment: Alignment(alignment.x, alignment.y + (index * 0.1)),
          timeStart: timeStart,
          timeEnd: timeEnd,
        ),
      );

      index++;
    }

    for (final l in _textAnimations) {
      await l.initialize(controller: controller);
    }
  }

  void paint({
    required Canvas canvas,
    required Size size,
  }) {
    for (final l in _textAnimations) {
      l.paint(canvas: canvas, size: size);
    }
  }
}
