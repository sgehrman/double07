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

  late final BlockAnimations _animation;

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
    final blocks = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          timeStart,
          timeEnd,
        ),
      ),
    );

    final opacity = _sequence.animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          timeStart,
          timeEnd,
        ),
      ),
    );

    _animation = BlockAnimations(opacity: opacity, blocks: blocks);
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
    // final rect = Offset.zero & size;

    final blockPaint = Paint()
      ..color = Colors.cyan.withOpacity(
        _animation.opacity.value,
      );

    // final rev = ReverseAnimation(_animation);

    // final gridPaint = Paint()
    //   ..color = Colors.cyan.withOpacity(
    //     rev.value,
    //   );

    // canvas.drawRect(rect, gridPaint);

    final width = size.height / 6; // shortest side is height

    final cols = size.width ~/ width;
    final rows = size.height ~/ width;

    final numBlocks = cols * rows;

    final n = (_animation.blocks.value * numBlocks).ceil();

    for (int i = 0; i < n; i++) {
      canvas.drawRect(
        rectForIndex(
          index: i,
          width: width,
          size: size,
        ),
        blockPaint,
      );
    }
  }
}

// =====================================================

class BlockAnimations {
  BlockAnimations({
    required this.opacity,
    required this.blocks,
  });

  Animation<double> opacity;
  Animation<double> blocks;
}
