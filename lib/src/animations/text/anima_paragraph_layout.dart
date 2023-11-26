import 'package:double07/src/animations/common_animations.dart';
import 'package:double07/src/animations/text/anima_text.dart';
import 'package:double07/src/animations/text/anima_text_state.dart';
import 'package:flutter/material.dart';

enum ParagraphLayoutStyle {
  stacked,
  singleLine,
}

class AnimaParagraphLayout {
  static List<AnimaText> paragraph({
    required List<AnimaTextLine> lines,
    required double begin,
    required double end,
    required Alignment alignment,
    double newLine = 0.08,
    double animateFrom = -2, // set to zero for no fly in
    bool outMode = false,
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
        final alignments = animateFrom != 0
            ? [
                Alignment(alignment.x, animateFrom),
                Alignment(alignment.x, alignment.y + (index * newLine)),
              ]
            : [
                Alignment(alignment.x, alignment.y + (index * newLine)),
                Alignment(alignment.x, alignment.y + (index * newLine)),
              ];

        double lineBegin = lineEnd;
        // all lines should draw at the same time in outMode
        if (outMode) {
          lineBegin = begin;
        }
        lineEnd = lineBegin + (line.textLengh * timePerChar);

        final state = AnimaTextState(
          line: line,
          alignments: alignments,
          timingInfo: AnimaTimingInfo(
            begin: lineBegin,
            end: lineEnd,
            outMode: outMode,
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
