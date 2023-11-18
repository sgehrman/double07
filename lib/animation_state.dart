import 'package:double07/animation_background_state.dart';
import 'package:double07/animation_ball_state.dart';
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
  final ballState = AnimationBallState();

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

      ballState.initialize(controller);

      isInitialized = true;
    }
  }
}
