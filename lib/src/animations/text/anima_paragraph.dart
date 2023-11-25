import 'package:double07/src/animation_sequence/animation_sequence.dart';
import 'package:double07/src/animations/common_animations.dart';
import 'package:double07/src/animations/text/anima_text.dart';
import 'package:double07/src/animations/text/anima_text_state.dart';
import 'package:flutter/material.dart';

enum ParagraphAnimaType {
  flyIn,
  titleSequence,
  weird,
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
      _animations = _buildSequence();
    } else if (type == ParagraphAnimaType.weird) {
      _animations = _buildSequence();
    } else if (type == ParagraphAnimaType.flyIn) {
      _animations = _buildSequence();
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

  List<AnimaText> _buildSequence() {
    final List<AnimaText> result = [];

    int charCount = 0;
    for (final line in lines) {
      charCount += line.textLengh;
    }

    final totalTime = timeEnd - timeStart;
    final timePerChar = totalTime / charCount;
    double end = timeStart;

    int index = 0;
    for (final line in lines) {
      // ignore blank lines
      if (!line.isBlank) {
        final start = end;
        end = start + (line.textLengh * timePerChar);

        final state = AnimaTextState(
          line: line,
          alignments: [
            if (animateFrom != 0) Alignment(alignment.x, animateFrom),
            if (animateFrom == 0)
              Alignment(alignment.x, alignment.y + (index * newLine)),
            Alignment(alignment.x, alignment.y + (index * newLine)),
          ],
          timingInfo: AnimaTimingInfo(
            begin: start,
            end: end,
            parentBegin: timeStart,
            parentEnd: timeEnd,
            numItems: line.textLengh,
            endDelay: 0,
          ),
        );

        result.add(
          AnimaText(state),
        );
      }

      index++;
    }

    return result;
  }
}
