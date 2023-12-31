import 'package:double07/src/animation_sequence/anima_elements.dart';
import 'package:double07/src/animation_sequence/runnable_animation.dart';
import 'package:flutter/material.dart';

class AnimationSequence {
  AnimationSequence();

  bool _isInitialized = false;

  final List<RunableAnimation> _runables = [
    AnimaElements.binoculars(),
    ...AnimaElements.backgrounds(),
    ...AnimaElements.easterEggs(),
    AnimaElements.deckrLogo(),
    AnimaElements.hendersonQuote(),
    AnimaElements.largoQuote(),
    AnimaElements.dominoQuote(),
    AnimaElements.randomQuote(),
    AnimaElements.theEnd(),
    AnimaElements.reviewsTitle(),
    AnimaElements.introTitles(),
    AnimaElements.double07Ball(),
    ...AnimaElements.blocks(),
  ];

  // =================================================

  bool get isInitialized => _isInitialized;

  Future<void> initialize(
    Animation<double> controller,
  ) async {
    if (!_isInitialized) {
      for (final item in _runables) {
        await item.initialize(controller);
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
