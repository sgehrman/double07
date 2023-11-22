import 'package:double07/src/animations/animation_specs/animation_spec.dart';
import 'package:flutter/material.dart';

class DoubleO7Animations extends AnimationSpec {
  DoubleO7Animations({
    required Animation<double> master,
    required Animation<double> parent,
    required this.animation,
  }) : super(master: master, parent: parent);

  Animation<double> animation;
}
