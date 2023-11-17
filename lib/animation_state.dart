import 'package:flutter/material.dart';

class AnimationState {
  AnimationState() {
    const TextStyle style = TextStyle(
      color: Colors.white54,
      // fontWeight: FontWeight.bold,
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

  double animationValue = 0;
  double textAnimValue = 0;

  double fadeBallPosition = -1;
  double fadeBallOpacity = 0;

  double fadeBallPosition2 = -1;
  double fadeBallOpacity2 = 0;

  int lastV = -1;

  void update(double value, double textValue) {
    animationValue = value;
    textAnimValue = textValue;

    final int v = (value * 100).round();

    if (v != lastV && (v % 15) == 0) {
      lastV = v;

      if (fadeBallPosition == -1) {
        fadeBallOpacity = 1;
        fadeBallPosition = value;
      } else if (fadeBallPosition2 == -1) {
        fadeBallOpacity2 = 1;
        fadeBallPosition2 = value;
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
