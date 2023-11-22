import 'package:double07/src/animations/animation_specs/animation_spec.dart';
import 'package:flutter/material.dart';

class BackgroundAnimations extends AnimationSpec {
  BackgroundAnimations({
    required Animation<double> master,
    required Animation<double> parent,
    required this.opacity,
    required this.scale,
  }) : super(master: master, parent: parent);

  Animation<double> opacity;
  Animation<double> scale;
}
