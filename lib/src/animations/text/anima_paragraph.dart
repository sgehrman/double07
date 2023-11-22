import 'package:double07/src/animation_state.dart';
import 'package:double07/src/animations/text/anima_text.dart';
import 'package:double07/src/animations/text/anima_text_state.dart';
import 'package:double07/src/animations/text/animation_paragraph_state.dart';
import 'package:flutter/material.dart';

class AnimaParagraph implements RunableAnimation {
  AnimaParagraph({
    required this.lines,
    required this.alignment,
    required this.timeStart,
    required this.timeEnd,
    this.type = ParagraphAnimaType.flyIn,
    this.newLine = 0.08,
    this.animateFrom = -2, // set to zero for no fly in
  });

  final List<AnimaTextLine> lines;
  final Alignment alignment;
  final double timeStart;
  final double timeEnd;
  final double newLine;
  final double animateFrom;
  final ParagraphAnimaType type;

  late final List<AnimaText> _animations;

  @override
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
          line: AnimaTextLine(
            text: line.text,
            fontSize: line.fontSize,
            curve: Curves.easeIn,
            animationTypes: const {
              TextAnimationType.alignment,
              TextAnimationType.fadeInOut,
              // TextAnimationType.opacity,
            },
            color: line.color,
          ),
          alignments: [
            Alignment(alignment.x, alignment.y),
            Alignment(alignment.x, alignment.y),
            // fades up and out
            Alignment(alignment.x, alignment.y - newLine),
          ],
          timeStart: start,
          timeEnd: end,
        );
      } else {
        final start = timeStart + (index * (timePerLine / overlap));
        final end = start + (timePerLine * overlap);

        state = AnimaTextState(
          line: AnimaTextLine(
            text: line.text,
            fontSize: line.fontSize,
            curve: Curves.easeInOut,
            color: line.color,
          ),
          alignments: [
            if (animateFrom != 0) Alignment(alignment.x, animateFrom),
            if (animateFrom == 0)
              Alignment(alignment.x, alignment.y + (index * newLine)),
            Alignment(alignment.x, alignment.y + (index * newLine)),
          ],
          timeStart: start,
          timeEnd: end,
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

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    for (final animation in _animations) {
      animation.paint(canvas, size);
    }
  }
}