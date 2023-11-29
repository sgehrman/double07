import 'package:double07/src/animations/animation_specs/animation_spec.dart';
import 'package:flutter/material.dart';

class BackgroundAnimations extends AnimationSpec {
  BackgroundAnimations({
    required List<Animation<double>> controllers,
    required this.opacity,
    required this.scale,
    required this.blur,
  }) : super(controllers: controllers);

  Animation<double> opacity;
  Animation<double> scale;
  Animation<double> blur;
}
