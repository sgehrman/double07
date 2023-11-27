import 'package:double07/src/animations/animation_specs/animation_spec.dart';
import 'package:flutter/material.dart';

class ImageAnimations extends AnimationSpec {
  ImageAnimations({
    required List<Animation<double>> controllers,
    required this.opacity,
    required this.alignment,
    required this.scale,
  }) : super(controllers: controllers);

  Animation<Alignment> alignment;
  Animation<double> opacity;
  Animation<double> scale;
}
