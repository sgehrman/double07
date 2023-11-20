import 'package:flutter/material.dart';

class AnimationBlocksState {
  AnimationBlocksState({
    required this.alignment,
    required this.timeStart,
    required this.timeEnd,
  });

  final Alignment alignment;
  final double timeStart;
  final double timeEnd;

  late final Animation<double> _animation;

  // expensive to alloc, create once
  final _sequence = TweenSequence<double>(
    <TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0, end: 0.35),
        weight: 33,
      ),
      TweenSequenceItem<double>(
        tween: ConstantTween<double>(0.35),
        weight: 33,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0.35, end: 0),
        weight: 33,
      ),
    ],
  );

  // =================================================

  void initialize(AnimationController controller) {
    _animation = _sequence.animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          timeStart,
          timeEnd,
        ),
      ),
    );
  }

  Rect rectForIndex({
    required int index,
    required double width,
    required Size size,
  }) {
    final cols = size.width ~/ width;

    final r = index ~/ cols;
    final c = index % cols;

    return Rect.fromLTWH(c * width, r * width, width, width).deflate(10);
  }

  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    final blockPaint = Paint()
      ..color = Colors.cyan.withOpacity(
        _animation.value,
      );

    final width = size.height / 6; // shortest side is height

    final cols = size.width ~/ width;
    final rows = size.height ~/ width;

    final numBlocks = cols * rows;

    for (int i = 0; i < numBlocks; i++) {
      canvas.drawRect(
        rectForIndex(
          index: i,
          width: width,
          size: size,
        ),
        blockPaint,
      );
    }

    canvas.drawRect(rect, blockPaint);
  }
}
