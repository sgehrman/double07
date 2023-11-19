import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class AnimatedTextInfo {
  AnimatedTextInfo({
    required this.image,
    required this.wordSize,
    required this.alignment,
    required this.size,
  });

  final Size wordSize;
  final Size size;
  final ui.Image image;
  final Alignment alignment;
}
