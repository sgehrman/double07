import 'package:double07/src/animations/animation_ball_state.dart';
import 'package:double07/src/elements/anima_elements.dart';
import 'package:flutter/material.dart';

abstract class RunableAnimation {
  void paint(Canvas canvas, Size size);
  Future<void> initialize(AnimationController controller);
}

// ========================================================

class AnimationState {
  AnimationState();

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
