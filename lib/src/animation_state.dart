import 'package:double07/src/animations/animation_background_state.dart';
import 'package:double07/src/animations/animation_ball_state.dart';
import 'package:double07/src/animations/animation_paragraph_state.dart';
import 'package:double07/src/animations/animation_text_state.dart';
import 'package:double07/src/timeline.dart';
import 'package:double07/src/utils.dart';
import 'package:flutter/material.dart';

class AnimationState {
  AnimationState();

  bool isInitialized = false;

  // Deckr animation
  final t1 = AnimationTextState(
    text: 'Deckr'.toUpperCase(),
    fontSize: 64,
    bold: true,
    color: Colors.white,
    startAlignment: const Alignment(-0.8, -2),
    endAlignment: const Alignment(-0.8, -0.8),
    timeStart: Timeline.textStart,
    timeEnd: Timeline.textEnd,
    curve: Curves.bounceOut,
  );

  // Coder animation
  final t2 = AnimationTextState(
    text: 'Code: Mr. Henderson',
    fontSize: 44,
    color: Colors.cyan,
    startAlignment: const Alignment(0.8, 2),
    endAlignment: const Alignment(0.8, 0.8),
    timeStart: Timeline.textStart2,
    timeEnd: Timeline.textEnd2,
  );

  final p1 = AnimationParagraphState(
    alignment: const Alignment(0.8, -0.8),
    timeStart: 0.5,
    timeEnd: 1,
    lines: [
      'This dream is for you',
      'So pay the price',
      'Make one dream come true',
      'You only live twice',
    ],
  );

  // ball animation
  final ballState = AnimationBallState();

  // background
  final backgroundState = AnimationBackgroundState(
    imageAsset: '$kAssets/images/henderson.png',
    alignment: const Alignment(-0.25, -0.3),
    timeStart: Timeline.hendersonStart,
    timeEnd: Timeline.hendersonEnd,
  );

  final backgroundState2 = AnimationBackgroundState(
    imageAsset: '$kAssets/images/largo.jpg',
    alignment: const Alignment(0.7, -0.1),
    timeStart: Timeline.largoStart,
    timeEnd: Timeline.largoEnd,
  );

  final backgroundState3 = AnimationBackgroundState(
    imageAsset: '$kAssets/images/domino.jpg',
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
      await p1.initialize(controller: controller);

      isInitialized = true;
    }
  }

  void paint(Canvas canvas, Size size) {
    backgroundState.paintBackground(canvas, size);
    backgroundState2.paintBackground(canvas, size);
    backgroundState3.paintBackground(canvas, size);

    t1.paint(
      canvas: canvas,
      size: size,
    );

    t2.paint(
      canvas: canvas,
      size: size,
    );

    p1.paint(
      canvas: canvas,
      size: size,
    );

    ballState.paint(canvas, size);
  }
}
