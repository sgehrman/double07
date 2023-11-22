import 'package:double07/src/animation_sequence/anima_elements.dart';
import 'package:double07/src/animations/anima_image/anima_image.dart';
import 'package:double07/src/animations/anima_image/anima_image_state.dart';
import 'package:double07/src/animations/animation_ball_state.dart';
import 'package:double07/src/utils.dart';
import 'package:flutter/material.dart';

abstract class RunableAnimation {
  void paint(Canvas canvas, Size size);
  Future<void> initialize(AnimationController controller);
}

// ========================================================

class AnimationSequence {
  AnimationSequence();

  bool isInitialized = false;

  final List<RunableAnimation> _runables = [
    ...AnimaElements.backgrounds(),
    AnimaElements.deckrLogo(),
    AnimaElements.hendersonQuote(),
    AnimaElements.largoQuote(),
    AnimaElements.dominoQuote(),
    AnimaElements.randomQuote(),
    AnimaElements.introTitles(),
    ...AnimaElements.blocks(),
    AnimationBallState(),
    AnimaImage(
      AnimaImageState(
        imageAsset: '$kAssets/images/egg.png',
        opacity: 0.9,
        size: const Size(400, 400),
        timeEnd: 0.3,
        timeStart: 0,
        alignments: [const Alignment(0, -0.1)],
      ),
    ),
  ];

  // =================================================

  Future<void> initialize(AnimationController controller) async {
    if (!isInitialized) {
      for (final item in _runables) {
        await item.initialize(controller);
      }

      isInitialized = true;
    }
  }

  void paint(Canvas canvas, Size size) {
    for (final item in _runables) {
      item.paint(canvas, size);
    }
  }
}
