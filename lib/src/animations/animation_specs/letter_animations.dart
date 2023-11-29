import 'package:double07/src/animations/animation_specs/animation_spec.dart';
import 'package:flutter/material.dart';

class LetterAnimations extends AnimationSpec {
  LetterAnimations({
    required List<Animation<double>> controllers,
    required this.scale,
    required this.alignment,
    required this.opacity,
  }) : super(
          controllers: controllers,
        );

  Animation<Alignment> alignment;
  Animation<double> opacity;
  Animation<double> scale;
}
