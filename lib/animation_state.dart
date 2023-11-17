import 'package:flutter/material.dart';

class AnimationState {
  AnimationState() {
    const TextStyle style = TextStyle(
      color: Colors.white54,
      fontSize: 64,
    );

    final TextSpan span12 = TextSpan(style: style, text: 'Deckr'.toUpperCase());
    textPainter = TextPainter(
      text: span12,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
  }

  late TextPainter textPainter;

  double ballValue = 0;
  double textAnimValue = 0;

  double fadeBallPosition = -1;
  double fadeBallOpacity = 0;

  double fadeBallPosition2 = -1;
  double fadeBallOpacity2 = 0;

  int lastV = -1;

  // state bools
  bool textDone = false;
  bool ballDone = false;

  // =================================================

  void reset() {
    textDone = false;
    ballDone = false;
  }

  // =================================================

  void update(double value, double textValue) {
    ballValue = value;
    textAnimValue = textValue;

    updateBall();
  }

  void updateBall() {
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
}
