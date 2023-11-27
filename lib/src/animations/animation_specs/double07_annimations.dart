import 'package:double07/src/animations/animation_specs/animation_spec.dart';
import 'package:flutter/material.dart';

class DoubleO7Animations extends AnimationSpec {
  DoubleO7Animations({
    required List<Animation<double>> controllers,
    required this.animation,
  }) : super(controllers: controllers);

  Animation<double> animation;
}
