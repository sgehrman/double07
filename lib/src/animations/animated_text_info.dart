import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class AnimatedTextInfo {
  AnimatedTextInfo({
    required this.painter,
    required this.image,
    required this.wordSize,
    required this.alignment,
  });

  final TextPainter painter;
  final Size wordSize;
  final ui.Image image;
  final Alignment alignment;
}
