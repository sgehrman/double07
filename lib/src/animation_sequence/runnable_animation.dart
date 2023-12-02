import 'package:flutter/material.dart';

abstract class RunableAnimation {
  bool outMode = false;

  void paint(Canvas canvas, Size size);
  Future<void> initialize(
    Animation<double> controller,
  );
}
