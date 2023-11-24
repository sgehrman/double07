import 'package:flutter/material.dart';

// whole point of this is to know if if the animation is running
// the base animation is based on the start and end, only used to know if > 0

abstract class AnimationSpec {
  AnimationSpec({
    required this.master,
    required this.parent,
  });

  final Animation<double> master;
  final Animation<double> parent;

  // not running if zero or one
  bool get isRunning {
    return master.value != 0 &&
        master.value != 1 &&
        parent.value != 0 &&
        parent.value != 1;
  }

  static Animation<double> parentAnimation({
    required AnimationController controller,
    required double begin,
    required double end,
  }) {
    return CurvedAnimation(
      parent: controller,
      curve: Interval(
        begin,
        end,
      ),
    );
  }
}
