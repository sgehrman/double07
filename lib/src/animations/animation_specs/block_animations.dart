import 'package:double07/src/animations/animation_specs/animation_spec.dart';
import 'package:flutter/material.dart';

class BlockAnimations extends AnimationSpec {
  BlockAnimations({
    required Animation<double> master,
    required Animation<double> parent,
    required this.opacity,
    required this.blocks,
    required this.flip,
    required this.color,
  }) : super(master: master, parent: parent);

  Animation<double> opacity;
  Animation<double> blocks;
  Animation<double> flip;
  Animation<Color?> color;
}
