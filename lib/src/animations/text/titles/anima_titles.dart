import 'package:double07/src/animation_sequence/runnable_animation.dart';
import 'package:double07/src/animations/animation_specs/animation_spec.dart';
import 'package:double07/src/animations/common_animations.dart';
import 'package:double07/src/animations/text/anima_text_state.dart';
import 'package:double07/src/animations/text/titles/anima_title_text.dart';
import 'package:flutter/material.dart';

class AnimaTitles extends RunableAnimation {
  AnimaTitles({
    required this.lines,
    required this.alignment,
    required this.timeStart,
    required this.timeEnd,
    this.animateDown = true,
  });

  final List<AnimaTextLine> lines;
  final Alignment alignment;
  final double timeStart;
  final double timeEnd;
  final bool animateDown;

  late final _AnimaParagraph _paragraph;

  @override
  Future<void> initialize(
    Animation<double> controller,
  ) async {
    _paragraph = _AnimaParagraph(
      lines: lines,
      alignment: alignment,
      animateDown: animateDown,
      timeEnd: timeEnd,
      timeStart: timeStart,
    );

    await _paragraph.initialize(controller);
  }

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    _paragraph.paint(canvas, size);
  }
}

// =========================================================

class _AnimaParagraph extends RunableAnimation {
  _AnimaParagraph({
    required this.lines,
    required this.alignment,
    required this.timeStart,
    required this.timeEnd,
    required this.animateDown, // set to zero for no fly in
  });

  final List<AnimaTextLine> lines;
  final Alignment alignment;
  final double timeStart;
  final double timeEnd;
  final bool animateDown;

  final List<AnimaTitleText> _animations = [];

  @override
  Future<void> initialize(
    Animation<double> controller,
  ) async {
    final totalTime = timeEnd - timeStart;
    final timePerLine = totalTime / lines.length;
    double lineEnd = timeStart;

    for (final line in lines) {
      // ignore blank lines
      if (!line.isBlank) {
        final double lineBegin = lineEnd;
        lineEnd = lineBegin + timePerLine;

        final state = AnimaTextState(
          line: line,
          alignments: AnimaAlignments(
            Alignment(alignment.x, alignment.y),
            from: animateDown
                ? Alignment(alignment.x, alignment.y - line.lineHeight)
                : null,
          ),
          timingInfo: AnimaTimingInfo(
            begin: 0,
            end: timePerLine,
            outMode: outMode,
            numItems: line.textLengh,
          ),
        );

        final animaTitle = AnimaTitleText(state);

        final subController = AnimationSpec.parentAnimation(
          parent: controller,
          begin: lineBegin,
          end: lineEnd,
        );

        await animaTitle.initialize(subController);

        _animations.add(animaTitle);
      }
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
