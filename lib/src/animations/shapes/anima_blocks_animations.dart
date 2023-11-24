import 'package:double07/src/animations/anima_utils.dart';
import 'package:double07/src/animations/animation_specs/animation_spec.dart';
import 'package:double07/src/animations/animation_specs/block_animations.dart';
import 'package:double07/src/animations/shapes/anima_blocks_state.dart';
import 'package:flutter/material.dart';

class AnimaBlocksAnimations {
  AnimaBlocksAnimations(this.state);

  final AnimaBlocksState state;

  late final BlockAnimations _animations;
  final Map<int, Rect> _rectCache = {};

  // =================================================

  Future<void> initialize(AnimationController controller) {
    final parent = AnimationSpec.parentAnimation(
      controller: controller,
      begin: state.timeStart,
      end: state.timeEnd,
    );

    final blocks = state.blocksSequence.animate(
      CurvedAnimation(
        parent: parent,
        curve: const Interval(
          0,
          1,
          curve: Curves.easeInOut,
        ),
      ),
    );

    final flip = state.flipSequence.animate(
      CurvedAnimation(
        parent: parent,
        curve: const Interval(
          0,
          1,
          curve: Curves.easeInOut,
        ),
      ),
    );

    final opacity = state.opacitySequence.animate(
      CurvedAnimation(
        parent: parent,
        curve: const Interval(
          0,
          1,
        ),
      ),
    );

    final color = state.colorSequence.animate(
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
      color: color,
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

      if (state.downward) {
        final rows = size.height ~/ width;

        c = index ~/ rows;
        r = index % rows;
      } else {
        final cols = size.width ~/ width;

        r = index ~/ cols;
        c = index % cols;
      }

      _rectCache[index] = Rect.fromLTWH(c * width, r * width, width, width)
          .deflate(state.margin);
    }

    return _rectCache[index]!;
  }

  // =====================================================

  void paint(Canvas canvas, Size size) {
    if (!_animations.isRunning) {
      // print('NOT RUNNING block');

      return;
    } else {
      // print('RUNNING block');
    }

    // final rect = Offset.zero & size;

    final animaColor = _animations.color.value;

    Color color = Colors.cyan;
    if (animaColor != null) {
      if (animaColor.opacity != 0) {
        color = animaColor;
      }
    }

    final blockPaint = Paint()
      ..color = color.withOpacity(
        _animations.opacity.value,
      );

    final width = size.height / state.numColumns; // shortest side is height

    final cols = size.width ~/ width;
    final rows = size.height ~/ width;

    final numBlocks = cols * rows;

    final n = (_animations.blocks.value * numBlocks).ceil();

    for (int i = 0; i < n; i++) {
      final index = state.reverse ? (numBlocks - 1) - i : i;

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

      if (state.circles) {
        canvas.drawCircle(
          destRect.center,
          destRect.width / 2,
          blockPaint,
        );
      } else {
        canvas.drawRect(
          destRect,
          blockPaint,
        );
      }

      canvas.restore();
    }
  }
}
