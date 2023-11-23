import 'package:double07/src/animation_sequence/animation_sequence.dart';
import 'package:double07/src/animations/text/anima_text.dart';
import 'package:double07/src/animations/text/anima_text_state.dart';
import 'package:flutter/material.dart';

enum ParagraphAnimaType {
  flyIn,
  titleSequence,
}

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
    if (type == ParagraphAnimaType.titleSequence) {
      _animations = buildTitleSequence();
    } else {
      _animations = buildNormalSequence();
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

  // ---------------------------------------------------------

  List<AnimaText> buildTitleSequence() {
    final List<AnimaText> result = [];

    final timePerLine = (timeEnd - timeStart) / lines.length;

    int index = 0;
    for (final line in lines) {
      AnimaTextState state;

      final start = timeStart + (index * timePerLine);
      final end = start + timePerLine;

      state = AnimaTextState(
        line: AnimaTextLine(
          text: line.text,
          fontSize: line.fontSize,
          inCurve: line.inCurve,
          outCurve: line.outCurve,
          animationTypes: const {
            TextAnimationType.alignment,
            TextAnimationType.fadeInOut,
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

      result.add(
        AnimaText(state),
      );

      index++;
    }

    return result;
  }

  // ---------------------------------------------------------

  List<AnimaText> buildNormalSequence() {
    final List<AnimaText> result = [];

    final timePerLine = (timeEnd - timeStart) / lines.length;

    int index = 0;
    for (final line in lines) {
      AnimaTextState state;

      const overlap = 2;
      final start = timeStart + (index * (timePerLine / overlap));
      final end = start + (timePerLine * overlap);

      state = AnimaTextState(
        line: AnimaTextLine(
          text: line.text,
          fontSize: line.fontSize,
          inCurve: line.inCurve,
          outCurve: line.outCurve,
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

      result.add(
        AnimaText(state),
      );

      index++;
    }

    return result;
  }
}
