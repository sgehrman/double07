import 'package:flutter/material.dart';

// whole point of this is to know if if the animation is running
// the base animation is based on the start and end, only used to know if > 0

class AnimationSpec {
  AnimationSpec({
    required this.parent,
  });

  final Animation<double> parent;

  bool get isRunning => parent.value > 0;

  static Animation<double> parentAnimation(
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
