import 'package:double07/src/animation_sequence/animation_sequence.dart';
import 'package:double07/src/animations/animation_specs/animation_spec.dart';
import 'package:double07/src/animations/text/anima_text_state.dart';
import 'package:double07/src/animations/text/paragraph/anima_paragraph_layout.dart';
import 'package:double07/src/animations/text/paragraph/anima_paragraph_text.dart';
import 'package:flutter/material.dart';

class AnimaParagraph extends RunableAnimation {
  AnimaParagraph({
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

  late final List<AnimaParagraphText> _outAnimations;
  late final List<AnimaParagraphText> _inAnimations;

  @override
  Future<void> initialize(
    Animation<double> controller,
  ) async {
    // calc times for in/out animations
    const outRatio = 0.1;
    final len = timeEnd - timeStart;
    final outDuration = outRatio * len;
    final inDuration = len - outDuration;

    double begin = timeStart;
    double end = begin + inDuration;

    final inSubController = AnimationSpec.parentAnimation(
      parent: controller,
      begin: begin,
      end: end,
    );

    begin = end;
    end = begin + outDuration;

    final outSubController = AnimationSpec.parentAnimation(
      parent: controller,
      begin: begin,
      end: end,
    );

    _inAnimations = AnimaParagraphLayout.paragraph(
      lines: lines,
      alignment: alignment,
      begin: 0,
      end: 0.7, // delay before fade out
      animateDown: animateDown,
      outMode: false,
    );

    _outAnimations = AnimaParagraphLayout.paragraph(
      lines: lines,
      alignment: alignment,
      begin: 0,
      end: 1,
      animateDown: animateDown,
      outMode: true,
    );

    for (final l in _inAnimations) {
      await l.initialize(inSubController);
    }

    for (final l in _outAnimations) {
      await l.initialize(outSubController);
    }
  }

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    for (final animation in _outAnimations) {
      animation.paint(canvas, size);
    }

    for (final animation in _inAnimations) {
      animation.paint(canvas, size);
    }
  }
}
