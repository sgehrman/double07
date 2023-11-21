import 'package:double07/src/animations/anima_utils.dart';
import 'package:double07/src/animations/animation_specs/animation_spec.dart';
import 'package:double07/src/animations/animation_specs/block_animations.dart';
import 'package:flutter/material.dart';

class AnimationBlocksState {
  AnimationBlocksState({
    required this.timeStart,
    required this.timeEnd,
  });

  final double timeStart;
  final double timeEnd;

  late final BlockAnimations _animation;
  final _reverse = false;
  final _downward = true;
  final Map<int, Rect> _rectCache = {};

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
      TweenSequenceItem<double>(
        tween: ConstantTween<double>(1),
        weight: 20,
      ),
    ],
  );

  final _flipSequence = TweenSequence<double>(
    <TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: ConstantTween<double>(0),
        weight: 44,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0, end: 0.4),
        weight: 10,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0.4, end: 0),
        weight: 10,
      ),
    ],
  );

  // =================================================

  void initialize(AnimationController controller) {
    final parent =
        AnimationSpec.parentAnimation(controller, timeStart, timeEnd);

    final blocks = _blocksSequence.animate(
      CurvedAnimation(
        parent: parent,
        curve: const Interval(
          0,
          1,
          curve: Curves.easeInOut,
        ),
      ),
    );

    final flip = _flipSequence.animate(
      CurvedAnimation(
        parent: parent,
        curve: const Interval(
          0,
          1,
          curve: Curves.easeInOut,
        ),
      ),
    );

    final opacity = _opacitySequence.animate(
      CurvedAnimation(
        parent: parent,
        curve: const Interval(
          0,
          1,
        ),
      ),
    );

    _animation = BlockAnimations(
      master: parent,
      parent: parent,
      opacity: opacity,
      blocks: blocks,
      flip: flip,
    );
  }

  // =====================================================

  Rect rectForIndex({
    required int index,
    required double width,
    required Size size,
  }) {
    if (_rectCache[index] == null) {
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

      _rectCache[index] =
          Rect.fromLTWH(c * width, r * width, width, width).deflate(10);
    }

    return _rectCache[index]!;
  }

  // =====================================================

  void paint(Canvas canvas, Size size) {
    if (!_animation.isRunning) {
      // print('NOT RUNNING block');

      return;
    } else {
      // print('RUNNING block');
    }

    // final rect = Offset.zero & size;

    final blockPaint = Paint()
      ..color = Colors.cyan.withOpacity(
        _animation.opacity.value,
      );

    final width = size.height / 6; // shortest side is height

    final cols = size.width ~/ width;
    final rows = size.height ~/ width;

    final numBlocks = cols * rows;

    final n = (_animation.blocks.value * numBlocks).ceil();

    for (int i = 0; i < n; i++) {
      final index = _reverse ? (numBlocks - 1) - i : i;

      final destRect = rectForIndex(
        index: index,
        width: width,
        size: size,
      );

      canvas.save();
      final t = AnimaUtils.rotateRect(
        srcRect: destRect,
        degreesY: (_animation.flip.value * 360).round(),
        degreesX: 0,
      );

      canvas.transform(t.storage);
      canvas.drawRect(
        destRect,
        blockPaint,
      );

      canvas.restore();
    }
  }
}
