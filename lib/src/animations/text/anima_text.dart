import 'package:double07/src/animation_sequence/animation_sequence.dart';
import 'package:double07/src/animations/common_animations.dart';
import 'package:double07/src/animations/text/anima_text_animations.dart';
import 'package:double07/src/animations/text/anima_text_state.dart';
import 'package:flutter/material.dart';

class AnimaText extends RunableAnimation {
  AnimaText(this.state);

  final AnimaTextState state;
  late final AnimaTextAnimations _animations;

  @override
  Future<void> initialize(AnimationController controller) async {
    _animations = AnimaTextAnimations(state);

    await _animations.initialize(controller: controller);
  }

  @override
  void paint(Canvas canvas, Size size) {
    _animations.paint(
      canvas: canvas,
      size: size,
    );
  }

  @override
  set outMode(bool mode) {
    _animations.outMode = mode;
  }

  // ================================================
  // static helper methods

  static List<AnimaText> paragraph({
    required List<AnimaTextLine> lines,
    required double begin,
    required double end,
    required Alignment alignment,
    double newLine = 0.08,
    double animateFrom = -2, // set to zero for no fly in
  }) {
    final List<AnimaText> result = [];

    int charCount = 0;
    for (final line in lines) {
      charCount += line.textLengh;
    }

    final totalTime = end - begin;
    final timePerChar = totalTime / charCount;
    double lineEnd = begin;

    int index = 0;
    for (final line in lines) {
      // ignore blank lines
      if (!line.isBlank) {
        final lineBegin = lineEnd;
        lineEnd = lineBegin + (line.textLengh * timePerChar);

        final state = AnimaTextState(
          line: line,
          alignments: [
            if (animateFrom != 0) Alignment(alignment.x, animateFrom),
            if (animateFrom == 0)
              Alignment(alignment.x, alignment.y + (index * newLine)),
            Alignment(alignment.x, alignment.y + (index * newLine)),
          ],
          timingInfo: AnimaTimingInfo(
            begin: lineBegin,
            end: lineEnd,
            numItems: line.textLengh,
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
