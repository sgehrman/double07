import 'package:double07/src/animations/common_animations.dart';
import 'package:double07/src/animations/text/anima_text.dart';
import 'package:double07/src/animations/text/anima_text_state.dart';
import 'package:flutter/material.dart';

enum ParagraphLayoutStyle {
  stacked,
  singleLine,
}

class AnimaParagraphLayout {
  static List<AnimaTextSegment> paragraph({
    required List<AnimaTextLine> lines,
    required double begin,
    required double end,
    required Alignment alignment,
    required double animateFrom,
    required bool outMode,
  }) {
    final List<AnimaTextSegment> result = [];

    int charCount = 0;
    for (final line in lines) {
      charCount += line.textLengh;
    }

    final totalTime = end - begin;
    final timePerChar = totalTime / charCount;
    double lineEnd = begin;

    double lineHeight = 0;

    for (final line in lines) {
      // ignore blank lines
      if (!line.isBlank) {
        final double lineBegin = lineEnd;
        lineEnd = lineBegin + (line.textLengh * timePerChar);

        final state = AnimaTextState(
          line: line,
          alignments: AnimaAlignments(
            Alignment(alignment.x, alignment.y + lineHeight),
            from: animateFrom != 0 ? Alignment(alignment.x, animateFrom) : null,
          ),
          timingInfo: AnimaTimingInfo(
            begin: lineBegin,
            end: lineEnd,
            outMode: outMode,
            numItems: line.textLengh,
          ),
        );

        result.add(
          AnimaTextSegment(state),
        );
      }

      lineHeight += line.lineHeight;
    }

    return result;
  }
}
