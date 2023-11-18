import 'package:double07/animation_background_state.dart';
import 'package:double07/animation_text_state.dart';
import 'package:flutter/material.dart';

class AnimationState {
  AnimationState();

  bool isInitialized = false;

  // Deckr animation
  final t1 = AnimationTextState(
    text: 'Deckr'.toUpperCase(),
    fontSize: 64,
    color: Colors.white,
    startAlignment: const Alignment(-0.8, -5),
    endAlignment: const Alignment(-0.8, -0.8),
  );

  // Coder animation
  final t2 = AnimationTextState(
    text: 'Code: Mr. Henderson',
    fontSize: 44,
    color: Colors.cyan,
    startAlignment: const Alignment(0.8, 5),
    endAlignment: const Alignment(0.8, 0.8),
  );

  // ball animation
  double ballValue = 0;
  double fadeBallPosition = -1;
  double fadeBallOpacity = 0;
  double fadeBallPosition2 = -1;
  double fadeBallOpacity2 = 0;
  int lastV = -1;

  // background
  final backgroundState = AnimationBackgroundState(
    imageAsset: 'assets/images/henderson.png',
    alignment: const Alignment(-0.25, -0.3),
    timeStart: 0.1,
    timeEnd: 0.5,
  );

  final backgroundState2 = AnimationBackgroundState(
    imageAsset: 'assets/images/domino.jpg',
    alignment: const Alignment(-0.25, -0.2),
    timeStart: 0.5,
    timeEnd: 0.95,
  );

  // =================================================

  Future<void> initialize(AnimationController controller) async {
    if (!isInitialized) {
      const double textStart = 0.2;
      const double textEnd = 0.9;

      const double textStart2 = 0.4;
      const double textEnd2 = 1;

      await t1.initialize(
        controller: controller,
        text: t1.text,
        tStart: textStart,
        tEnd: textEnd,
      );

      await t2.initialize(
        controller: controller,
        text: t2.text,
        tStart: textStart2,
        tEnd: textEnd2,
      );

      await backgroundState.initialize(controller);
      await backgroundState2.initialize(controller);

      isInitialized = true;
    }
  }

  // =================================================

  void update(
    double value,
  ) {
    ballValue = value;

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
