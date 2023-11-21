import 'package:double07/src/animation_state.dart';
import 'package:double07/src/animations/anima_utils.dart';
import 'package:double07/src/animations/animation_specs/animation_spec.dart';
import 'package:double07/src/animations/animation_specs/block_animations.dart';
import 'package:flutter/material.dart';

class AnimationBlocksState implements RunableAnimation {
  AnimationBlocksState({
    required this.timeStart,
    required this.timeEnd,
    this.reverse = false,
    this.downward = false,
    this.numColumns = 6,
  });

  final double timeStart;
  final double timeEnd;
  final bool reverse;
  final bool downward;
  final int numColumns;

  late final BlockAnimations _animations;
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

  @override
  Future<void> initialize(AnimationController controller) {
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

    _animations = BlockAnimations(
      master: parent,
      parent: parent,
      opacity: opacity,
      blocks: blocks,
      flip: flip,
    );

    return Future.value();
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

      if (downward) {
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

  @override
  void paint(Canvas canvas, Size size) {
    if (!_animations.isRunning) {
      // print('NOT RUNNING block');

      return;
    } else {
      // print('RUNNING block');
    }

    // final rect = Offset.zero & size;

    final blockPaint = Paint()
      ..color = Colors.cyan.withOpacity(
        _animations.opacity.value,
      );

    final width = size.height / numColumns; // shortest side is height

    final cols = size.width ~/ width;
    final rows = size.height ~/ width;

    final numBlocks = cols * rows;

    final n = (_animations.blocks.value * numBlocks).ceil();

    for (int i = 0; i < n; i++) {
      final index = reverse ? (numBlocks - 1) - i : i;

      final destRect = rectForIndex(
        index: index,
        width: width,
        size: size,
      );

      canvas.save();
      final t = AnimaUtils.rotateRect(
        srcRect: destRect,
        degreesY: (_animations.flip.value * 360).round(),
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
