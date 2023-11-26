import 'package:double07/src/animation_sequence/anima_elements.dart';
import 'package:flutter/material.dart';

abstract class RunableAnimation {
  bool outMode = false;

  void paint(Canvas canvas, Size size);
  Future<void> initialize(
    AnimationController controller,
    Animation<double>? owner,
  );
}

// ========================================================

class AnimationSequence {
  AnimationSequence();

  bool _isInitialized = false;

  final List<RunableAnimation> _runables = [
    ...AnimaElements.backgrounds(),
    ...AnimaElements.easterEggs(),
    AnimaElements.deckrLogo(),
    AnimaElements.hendersonQuote(),
    AnimaElements.largoQuote(),
    AnimaElements.dominoQuote(),

    // AnimaElements.randomQuote(),

    AnimaElements.reviewsTitle(),
    AnimaElements.introTitles(),
    AnimaElements.double07Ball(),
    ...AnimaElements.blocks(),
  ];

  // =================================================

  bool get isInitialized => _isInitialized;

  Future<void> initialize(
    AnimationController controller,
    Animation<double>? owner,
  ) async {
    if (!_isInitialized) {
      for (final item in _runables) {
        await item.initialize(controller, owner);
      }

      _isInitialized = true;
    }
  }

  void paint(Canvas canvas, Size size) {
    for (final item in _runables) {
      item.paint(canvas, size);
    }
  }
}
