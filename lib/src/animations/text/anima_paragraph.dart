import 'package:double07/src/animation_sequence/animation_sequence.dart';
import 'package:double07/src/animations/anima_controlller.dart';
import 'package:double07/src/animations/animation_specs/animation_spec.dart';
import 'package:double07/src/animations/text/anima_paragraph_layout.dart';
import 'package:double07/src/animations/text/anima_text.dart';
import 'package:double07/src/animations/text/anima_text_state.dart';
import 'package:flutter/material.dart';

class AnimaParagraph extends RunableAnimation {
  AnimaParagraph({
    required this.lines,
    required this.alignment,
    required this.timeStart,
    required this.timeEnd,
    this.newLine = 0.08,
    this.animateFrom = -2, // set to zero for no fly in
  });

  final List<AnimaTextLine> lines;
  final Alignment alignment;
  final double timeStart;
  final double timeEnd;
  final double newLine;
  final double animateFrom;

  late final AnimaController _controller;

  @override
  Future<void> initialize(
    AnimationController controller,
    Animation<double>? owner,
  ) async {
    final _AnimaParagraph paragraph = _AnimaParagraph(
      lines: lines,
      alignment: alignment,
      animateFrom: animateFrom,
      newLine: newLine,
      timeEnd: timeEnd,
      timeStart: timeStart,
    );

    _controller = AnimaController(
      begin: timeStart,
      end: timeEnd,
      runnable: paragraph,
    );

    await _controller.initialize(controller, owner);
  }

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    _controller.paint(canvas, size);
  }
}

// =========================================================

class _AnimaParagraph extends RunableAnimation {
  _AnimaParagraph({
    required this.lines,
    required this.alignment,
    required this.timeStart,
    required this.timeEnd,
    required this.newLine,
    required this.animateFrom, // set to zero for no fly in
  });

  final List<AnimaTextLine> lines;
  final Alignment alignment;
  final double timeStart;
  final double timeEnd;
  final double newLine;
  final double animateFrom;

  late final List<AnimaText> _outAnimations;
  late final List<AnimaText> _inAnimations;

  @override
  Future<void> initialize(
    AnimationController controller,
    Animation<double>? owner,
  ) async {
    final double half = (timeEnd - timeStart) / 2;
    double begin = timeStart;
    double end = begin + half;

    _inAnimations = AnimaParagraphLayout.paragraph(
      lines: lines,
      alignment: alignment,
      begin: begin,
      end: end,
      animateFrom: animateFrom,
      newLine: newLine,
    );

    final inParent = AnimationSpec.parentAnimation(
      parent: controller,
      begin: begin,
      end: end,
    );

    for (final l in _inAnimations) {
      await l.initialize(controller, inParent);
    }

    begin = end;
    end = begin + half;

    _outAnimations = AnimaParagraphLayout.paragraph(
      lines: lines,
      alignment: alignment,
      begin: begin,
      end: end,
      animateFrom: animateFrom,
      newLine: newLine,
      outMode: true,
    );

    final outParent = AnimationSpec.parentAnimation(
      parent: controller,
      begin: begin,
      end: end,
    );

    for (final l in _outAnimations) {
      await l.initialize(controller, outParent);
    }
  }

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    if (outMode) {
      for (final animation in _outAnimations) {
        animation.paint(canvas, size);
      }
    } else {
      for (final animation in _inAnimations) {
        animation.paint(canvas, size);
      }
    }
  }
}
