import 'package:double07/src/animations/animation_specs/animation_spec.dart';
import 'package:flutter/material.dart';

class LetterAnimations extends AnimationSpec {
  LetterAnimations({
    required Animation<double> master,
    required Animation<double> parent,
    required this.scale,
    required this.alignment,
    required this.opacity,
  }) : super(
          master: master,
          parent: parent,
          keepAlive: true,
        );

  Animatable<Alignment> alignment;
  Animatable<double> opacity;
  Animatable<double> scale;
}
