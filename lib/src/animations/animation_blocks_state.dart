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
  final _reverse = false;
  final _downward = true;

  // expensive to alloc, create once
  final _opacitySequence = TweenSequence<double>(
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

  final _blocksSequence = TweenSequence<double>(
    <TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0, end: 0.35),
        weight: 10,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0.35, end: 0.1),
        weight: 10,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0.1, end: 0.8),
        weight: 4,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0.8, end: 0),
        weight: 10,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0, end: 1),
        weight: 10,
      ),
    ],
  );

  // =================================================

  void initialize(AnimationController controller) {
    final blocks = _blocksSequence.animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          timeStart,
          timeEnd,
          curve: Curves.easeInOut,
        ),
      ),
    );

    final opacity = _opacitySequence.animate(
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

  // =====================================================

  Rect rectForIndex({
    required int index,
    required double width,
    required Size size,
  }) {
    int c;
    int r;

    if (_downward) {
      final rows = size.height ~/ width;

      c = index ~/ rows;
      r = index % rows;
    } else {
      final cols = size.width ~/ width;

      r = index ~/ cols;
      c = index % cols;
    }

    return Rect.fromLTWH(c * width, r * width, width, width).deflate(10);
  }

  // =====================================================

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
      final index = _reverse ? (numBlocks - 1) - i : i;

      canvas.drawRect(
        rectForIndex(
          index: index,
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
