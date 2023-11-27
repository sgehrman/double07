import 'package:double07/src/animation_sequence/animation_sequence.dart';
import 'package:double07/src/animations/animation_specs/animation_spec.dart';
import 'package:double07/src/animations/animation_specs/double07_annimations.dart';
import 'package:double07/src/timeline.dart';
import 'package:flutter/material.dart';

class AnimaDouble07 extends RunableAnimation {
  late final DoubleO7Animations _animations;

  // ball animation
  double fadeBallPosition = -1;
  double fadeBallOpacity = 0;
  double fadeBallPosition2 = -1;
  double fadeBallOpacity2 = 0;
  int lastV = -1;
  Color ballColor = Colors.cyan;

  // =================================================

  @override
  Future<void> initialize(
    Animation<double> controller,
  ) {
    final sequence = TweenSequence<double>(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0, end: 1),
          weight: 50,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0, end: 1),
          weight: 50,
        ),
      ],
    );

    final parent = AnimationSpec.parentAnimation(
      parent: controller,
      begin: Timeline.ballStart,
      end: Timeline.ballEnd,
    );

    _animations = DoubleO7Animations(
      controllers: [controller],
      animation: sequence.animate(
        parent,
      ),
    );

    return Future.value();
  }

  // =================================================

  void _update() {
    final ballValue = _animations.animation.value;

    final int v = (ballValue * 100).round();

    if (v != lastV && (v % 15) == 0) {
      lastV = v;

      if (fadeBallPosition == -1) {
        fadeBallOpacity = 1;
        fadeBallPosition = ballValue;
      } else if (fadeBallPosition2 == -1) {
        fadeBallOpacity2 = 1;
        fadeBallPosition2 = ballValue;
      }
    }

    if (fadeBallPosition != -1) {
      fadeBallOpacity -= 0.015;

      if (fadeBallOpacity < 0) {
        fadeBallPosition = -1;
      }
    }

    if (fadeBallPosition2 != -1) {
      fadeBallOpacity2 -= 0.015;

      if (fadeBallOpacity2 < 0) {
        fadeBallPosition2 = -1;
      }
    }
  }

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    if (_animations.isRunning) {
      const double ballRadius = 100;
      final ballPaint = Paint()..color = ballColor;

      _update();

      canvas.drawCircle(
        Offset(
          size.width * _animations.animation.value,
          size.height / 2,
        ),
        ballRadius,
        ballPaint,
      );

      // fade ball
      if (fadeBallPosition != -1) {
        final ballFadePaint = Paint()
          ..color = ballColor.withOpacity(fadeBallOpacity);

        canvas.drawCircle(
          Offset(
            size.width * fadeBallPosition,
            size.height / 2,
          ),
          ballRadius,
          ballFadePaint,
        );
      }

      if (fadeBallPosition2 != -1) {
        final ballFadePaint = Paint()
          ..color = ballColor.withOpacity(fadeBallOpacity2);

        canvas.drawCircle(
          Offset(
            size.width * fadeBallPosition2,
            size.height / 2,
          ),
          ballRadius,
          ballFadePaint,
        );
      }
    }
  }
}
