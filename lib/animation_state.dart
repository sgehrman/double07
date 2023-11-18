import 'package:double07/animation_background_state.dart';
import 'package:double07/animation_text_state.dart';
import 'package:double07/timeline.dart';
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
    timeStart: Timeline.textStart,
    timeEnd: Timeline.textEnd,
  );

  // Coder animation
  final t2 = AnimationTextState(
    text: 'Code: Mr. Henderson',
    fontSize: 44,
    color: Colors.cyan,
    startAlignment: const Alignment(0.8, 5),
    endAlignment: const Alignment(0.8, 0.8),
    timeStart: Timeline.textStart2,
    timeEnd: Timeline.textEnd2,
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
    timeStart: Timeline.hendersonStart,
    timeEnd: Timeline.hendersonEnd,
  );

  final backgroundState2 = AnimationBackgroundState(
    imageAsset: 'assets/images/drago.jpg',
    alignment: const Alignment(0.7, -0.1),
    timeStart: Timeline.dragoStart,
    timeEnd: Timeline.dragoEnd,
  );

  final backgroundState3 = AnimationBackgroundState(
    imageAsset: 'assets/images/domino.jpg',
    alignment: const Alignment(-0.1, -0.2),
    timeStart: Timeline.dominoStart,
    timeEnd: Timeline.dominoEnd,
  );

  // =================================================

  Future<void> initialize(AnimationController controller) async {
    if (!isInitialized) {
      await t1.initialize(
        controller: controller,
      );

      await t2.initialize(
        controller: controller,
      );

      await backgroundState.initialize(controller);
      await backgroundState2.initialize(controller);
      await backgroundState3.initialize(controller);

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
