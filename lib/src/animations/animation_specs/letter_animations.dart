import 'package:double07/src/animations/animation_specs/animation_spec.dart';
import 'package:flutter/material.dart';

class LetterAnimations extends AnimationSpec {
  LetterAnimations({
    required Animation<double> master,
    required Animation<double> parent,
    required this.alignment,
    required this.opacity,
    required this.scale,
  }) : super(
          master: master,
          parent: parent,
        );

  Animation<Alignment> alignment;
  Animation<double> opacity;
  Animation<double> scale;
}
