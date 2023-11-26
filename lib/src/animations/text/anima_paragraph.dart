import 'package:double07/src/animation_sequence/animation_sequence.dart';
import 'package:double07/src/animations/anima_controlller.dart';
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

  late final _AnimaParagraph _paragraph;
  late final AnimaController _controller;

  @override
  Future<void> initialize(AnimationController controller) async {
    _paragraph = _AnimaParagraph(
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
      runnable: _paragraph,
    );

    await _controller.initialize(controller);
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

  late final List<AnimaText> _animations;

  @override
  Future<void> initialize(AnimationController controller) async {
    _animations = AnimaText.paragraph(
      lines: lines,
      alignment: alignment,
      begin: timeStart,
      end: timeEnd,
      animateFrom: animateFrom,
      newLine: newLine,
    );

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

  @override
  set outMode(bool mode) {
    for (final animation in _animations) {
      animation.outMode = mode;
    }
  }
}
