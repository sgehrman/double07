import 'package:flutter/material.dart';

enum TextAnimationType {
  alignment,
  scale,
  opacity,
}

class AnimationTextState {
  AnimationTextState({
    required this.text,
    required this.fontSize,
    required this.color,
    required this.startAlignment,
    required this.endAlignment,
    required this.timeStart,
    required this.timeEnd,
    this.curve = Curves.elasticInOut,
    this.bold = false,
    this.letterSpacing = 10,
    this.opacity = 0.3,
    this.animationTypes = const {
      TextAnimationType.alignment,
      TextAnimationType.scale,
      TextAnimationType.opacity,
    },
  });

  final String text;
  final double fontSize;
  final double opacity;
  final bool bold;
  final Color color;
  final Alignment startAlignment;
  final Alignment endAlignment;
  final double timeStart;
  final double timeEnd;
  final Curve curve;
  final double letterSpacing;
  final Set<TextAnimationType> animationTypes;
}
