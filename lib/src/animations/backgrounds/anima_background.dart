import 'package:double07/src/animation_sequence/animation_sequence.dart';
import 'package:double07/src/animations/backgrounds/anima_background_animations.dart';
import 'package:double07/src/animations/backgrounds/anima_background_binoculars.dart';
import 'package:double07/src/animations/backgrounds/anima_background_state.dart';
import 'package:flutter/material.dart';

class AnimaBackground extends RunableAnimation {
  AnimaBackground(this.state);

  final AnimaBackgroundState state;
  AnimaBackgroundAnimations? _animations;
  AnimaBackgroundBinoculars? _binoculars;

  @override
  Future<void> initialize(
    Animation<double> controller,
  ) async {
    switch (state.mode) {
      case AnimaBackgroundMode.zoomIn:
      case AnimaBackgroundMode.spotlight:
        _animations = AnimaBackgroundAnimations(state);
        break;
      case AnimaBackgroundMode.binoculars:
        _binoculars = AnimaBackgroundBinoculars(state);
        break;
    }

    await _animations?.initialize(controller);
    await _binoculars?.initialize(controller);
  }

  @override
  void paint(Canvas canvas, Size size) {
    _animations?.paint(canvas, size);
    _binoculars?.paint(canvas, size);
  }
}
