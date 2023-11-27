import 'package:double07/src/animation_sequence/animation_sequence.dart';
import 'package:double07/src/animations/animation_specs/animation_spec.dart';
import 'package:flutter/material.dart';

class AnimaController extends RunableAnimation {
  AnimaController({
    required this.begin,
    required this.end,
    required this.runnable,
  });

  final double begin;
  final double end;

  late final Animation<double> _outModeInterval;

  final RunableAnimation runnable;

  @override
  Future<void> initialize(
    Animation<double> controller,
  ) async {
    _outModeInterval = AnimationSpec.parentAnimation(
      parent: controller,
      begin: begin,
      end: end,
    );

    await runnable.initialize(controller);
  }

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final val = _outModeInterval.value;

    if (val > 0.5) {
      if (!outMode) {
        outMode = !outMode;

        runnable.outMode = outMode;
      }
    } else {
      if (outMode) {
        outMode = !outMode;

        runnable.outMode = outMode;
      }
    }

    runnable.paint(canvas, size);
  }
}
