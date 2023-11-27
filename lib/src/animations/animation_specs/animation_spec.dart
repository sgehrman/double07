import 'package:flutter/material.dart';

// whole point of this is to know if if the animation is running
// the base animation is based on the start and end, only used to know if > 0

abstract class AnimationSpec {
  AnimationSpec({
    required this.controllers,
  });

  final List<Animation<double>> controllers;

  // not running if zero or one
  bool get isRunning {
    return controllers.first.value != 0 && controllers.first.value != 1;
  }

  static Animation<double> parentAnimation({
    required Animation<double> parent,
    required double begin,
    required double end,
  }) {
    return CurvedAnimation(
      parent: parent,
      curve: Interval(
        begin,
        end,
      ),
    );
  }
}
