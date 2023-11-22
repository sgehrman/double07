import 'package:double07/src/animation_sequence/anima_elements.dart';
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
    AnimaElements.easterEgg(),
    // AnimaElements.deckrLogo(),
    AnimaElements.hendersonQuote(),
    AnimaElements.largoQuote(),
    AnimaElements.dominoQuote(),

    // AnimaElements.randomQuote(),
    AnimaElements.reviewsTitle(),
    AnimaElements.introTitles(),
    AnimaElements.double07Ball(),
    // ...AnimaElements.blocks(),
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
