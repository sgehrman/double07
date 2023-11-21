import 'package:flutter/material.dart';

// whole point of this is to know if if the animation is running
// the base animation is based on the start and end, only used to know if > 0

class AnimationSpec {
  AnimationSpec({
    required this.controller,
    required this.start,
    required this.end,
  }) : base = _base(controller, start, end);

  AnimationController controller;

  final Animation<double> base;
  final double start;
  final double end;

  bool get isRunning => base.value > 0;

  static Animation<double> _base(
    AnimationController controller,
    double start,
    double end,
  ) {
    return Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          start,
          end,
        ),
      ),
    );
  }
}
