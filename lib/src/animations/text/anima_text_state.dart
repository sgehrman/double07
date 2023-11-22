import 'package:flutter/material.dart';

enum TextAnimationType {
  alignment,
  scale,
  opacity,
  fadeInOut,
}

class AnimaTextState {
  AnimaTextState({
    required this.line,
    required this.alignments,
    required this.timeStart,
    required this.timeEnd,
  });

  final AnimaTextLine line;
  final List<Alignment> alignments;
  final double timeStart;
  final double timeEnd;

  // foreward to line
  String get text => line.text;
  double get fontSize => line.fontSize;
  double get opacity => line.opacity;
  double get letterSpacing => line.letterSpacing;
  bool get bold => line.bold;
  Color get color => line.color;
  Curve get curve => line.curve;
  Curve get opacityCurve => line.opacityCurve;
  Set<TextAnimationType> get animationTypes => line.animationTypes;
}

// ==============================================================

class AnimaTextLine {
  AnimaTextLine({
    required this.text,
    required this.fontSize,
    this.color = Colors.white,
    this.curve = Curves.elasticInOut,
    this.opacityCurve = Curves.easeOut,
    this.bold = false,
    this.letterSpacing = 6,
    this.opacity = 0.3,
    this.animationTypes = const {
      TextAnimationType.alignment,
      TextAnimationType.scale,
      TextAnimationType.opacity,
    },
  });

  AnimaTextLine.blank()
      : text = '',
        fontSize = 12,
        bold = false,
        letterSpacing = 6,
        opacity = 0.3,
        color = Colors.white,
        opacityCurve = Curves.ease,
        curve = Curves.ease,
        animationTypes = {};

  final String text;
  final double fontSize;
  final double opacity;
  final bool bold;
  final Color color;
  final Curve curve;
  final Curve opacityCurve;
  final double letterSpacing;
  final Set<TextAnimationType> animationTypes;
}
