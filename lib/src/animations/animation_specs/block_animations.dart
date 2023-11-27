import 'package:double07/src/animations/animation_specs/animation_spec.dart';
import 'package:flutter/material.dart';

class BlockAnimations extends AnimationSpec {
  BlockAnimations({
    required List<Animation<double>> controllers,
    required this.opacity,
    required this.blocks,
    required this.flip,
    required this.color,
  }) : super(controllers: controllers);

  Animation<double> opacity;
  Animation<double> blocks;
  Animation<double> flip;
  Animation<Color?> color;
}
