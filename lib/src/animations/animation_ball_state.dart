import 'package:double07/src/animations/animation_utils.dart';
import 'package:double07/src/timeline.dart';
import 'package:flutter/material.dart';

class AnimationBallState {
  late final Animation<double> _animation;

  // ball animation
  double fadeBallPosition = -1;
  double fadeBallOpacity = 0;
  double fadeBallPosition2 = -1;
  double fadeBallOpacity2 = 0;
  int lastV = -1;
  Color ballColor = Colors.cyan;

  // =================================================

  void initialize(AnimationController controller) {
    _animation = TweenSequence<double>(
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
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          Timeline.ballStart,
          Timeline.ballEnd,
        ),
      ),
    );
  }

  // =================================================

  void _update() {
    final ballValue = _animation.value;

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

  void paint(
    Canvas canvas,
    Size size,
  ) {
    if (AnimaUtils.isRunning(_animation)) {
      const double ballRadius = 100;
      final ballPaint = Paint()..color = ballColor;

      _update();

      canvas.drawCircle(
        Offset(
          size.width * _animation.value,
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
