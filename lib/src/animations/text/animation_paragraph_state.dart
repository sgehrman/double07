import 'package:double07/src/animations/text/anima_text.dart';
import 'package:double07/src/animations/text/anima_text_state.dart';
import 'package:flutter/material.dart';

enum ParagraphAnimaType {
  flyIn,
  titleSequence,
}

class AnimationParagraphState {
  AnimationParagraphState({
    required this.lines,
    required this.alignment,
    required this.timeStart,
    required this.timeEnd,
    this.curve = Curves.elasticInOut,
    this.type = ParagraphAnimaType.titleSequence,
  });

  final List<String> lines;
  final Alignment alignment;
  final double timeStart;
  final double timeEnd;
  final Curve curve;
  final ParagraphAnimaType type;

  late final List<AnimaText> _animations;

  Future<void> initialize({
    required AnimationController controller,
  }) async {
    _animations = [];

    final timePerLine = (timeEnd - timeStart) / lines.length;
    const overlap = 2;

    int index = 0;
    for (final line in lines) {
      AnimaTextState state;

      if (type == ParagraphAnimaType.titleSequence) {
        final start = timeStart;
        final end = start + timePerLine;

        state = AnimaTextState(
          text: line,
          fontSize: 44,
          color: Colors.white,
          startAlignment: Alignment(alignment.x, alignment.y),
          endAlignment: Alignment(alignment.x, alignment.y),
          timeStart: start,
          timeEnd: end,
          curve: Curves.easeInOut,
          animationTypes: const {
            TextAnimationType.alignment,
            TextAnimationType.fadeInOut,
            // TextAnimationType.opacity,
          },
        );
      } else {
        final start = timeStart + (index * (timePerLine / overlap));
        final end = start + (timePerLine * overlap);

        state = AnimaTextState(
          text: line,
          fontSize: 44,
          color: Colors.white,
          startAlignment: Alignment(alignment.x, -2),
          endAlignment: Alignment(alignment.x, alignment.y + (index * 0.1)),
          timeStart: start,
          timeEnd: end,
          curve: Curves.easeInOut,
        );
      }

      _animations.add(
        AnimaText(state),
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
