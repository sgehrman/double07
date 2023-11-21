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
    required this.fontSize,
    this.curve = Curves.elasticInOut,
    this.type = ParagraphAnimaType.flyIn,
  });

  final List<String> lines;
  final Alignment alignment;
  final double timeStart;
  final double fontSize;
  final double timeEnd;
  final Curve curve;
  final ParagraphAnimaType type;

  late final List<AnimaText> _animations;

  Future<void> initialize(AnimationController controller) async {
    _animations = [];

    final timePerLine = (timeEnd - timeStart) / lines.length;
    const overlap = 2;

    int index = 0;
    for (final line in lines) {
      AnimaTextState state;

      if (type == ParagraphAnimaType.titleSequence) {
        final start = timeStart + (index * timePerLine);
        final end = start + timePerLine;

        state = AnimaTextState(
          text: line,
          fontSize: fontSize,
          color: Colors.white,
          alignments: [
            Alignment(alignment.x, alignment.y),
            Alignment(alignment.x, alignment.y),
            Alignment(alignment.x, alignment.y - 0.2),
          ],
          timeStart: start,
          timeEnd: end,
          curve: Curves.easeIn,
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
          fontSize: fontSize,
          color: Colors.white,
          alignments: [
            Alignment(alignment.x, -2),
            Alignment(alignment.x, alignment.y + (index * 0.1)),
          ],
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
      await l.initialize(controller);
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
