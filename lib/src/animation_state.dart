import 'package:double07/src/animations/animation_background_state.dart';
import 'package:double07/src/animations/animation_ball_state.dart';
import 'package:double07/src/animations/shapes/anima_blocks.dart';
import 'package:double07/src/animations/shapes/anima_blocks_state.dart';
import 'package:double07/src/animations/shapes/anima_blocks_utils.dart';
import 'package:double07/src/animations/text/anima_text.dart';
import 'package:double07/src/animations/text/anima_text_state.dart';
import 'package:double07/src/animations/text/animation_paragraph_state.dart';
import 'package:double07/src/timeline.dart';
import 'package:double07/src/utils.dart';
import 'package:flutter/material.dart';

abstract class RunableAnimation {
  void paint(Canvas canvas, Size size);
  Future<void> initialize(AnimationController controller);
}

// ========================================================

class AnimationState {
  AnimationState();

  bool isInitialized = false;

  final List<RunableAnimation> _runables = [
    // background
    AnimationBackgroundState(
      imageAsset: '$kAssets/images/henderson.png',
      alignment: const Alignment(-0.25, -0.3),
      timeStart: Timeline.hendersonStart,
      timeEnd: Timeline.hendersonEnd,
    ),

    AnimationBackgroundState(
      imageAsset: '$kAssets/images/largo.jpg',
      alignment: const Alignment(0.7, -0.1),
      timeStart: Timeline.largoStart,
      timeEnd: Timeline.largoEnd,
    ),

    AnimationBackgroundState(
      imageAsset: '$kAssets/images/domino.jpg',
      alignment: const Alignment(-0.1, -0.2),
      timeStart: Timeline.dominoStart,
      timeEnd: Timeline.dominoEnd,
    ),
    // Deckr animation
    AnimaText(
      AnimaTextState(
        text: 'Deckr'.toUpperCase(),
        fontSize: 64,
        bold: true,
        color: Colors.white,
        alignments: [
          const Alignment(-0.8, -2),
          const Alignment(-0.8, -0.8),
        ],
        timeStart: Timeline.textStart,
        timeEnd: Timeline.textEnd,
      ),
    ),

    AnimaText(
      AnimaTextState(
        text: 'Mr. Henderson',
        fontSize: 44,
        color: Colors.cyan,
        alignments: [
          const Alignment(-0.2, 0.6),
          const Alignment(-0.2, 0.6),
        ],
        timeStart: Timeline.hendersonTextStart,
        timeEnd: Timeline.hendersonTextEnd,
      ),
    ),

    AnimaText(
      AnimaTextState(
        text: 'Largo',
        fontSize: 44,
        color: Colors.cyan,
        alignments: [
          const Alignment(0.6, 0.9),
          const Alignment(0.6, 0.9),
        ],
        timeStart: Timeline.largoTextStart,
        timeEnd: Timeline.largoTextEnd,
      ),
    ),

    AnimaText(
      AnimaTextState(
        text: 'Domino',
        fontSize: 44,
        color: Colors.cyan,
        alignments: [
          const Alignment(-0.12, 0.8),
          const Alignment(-0.12, 0.8),
        ],
        timeStart: Timeline.dominoTextStart,
        timeEnd: Timeline.dominoTextEnd,
      ),
    ),

    AnimationParagraphState(
      alignment: const Alignment(0.8, -0.8),
      fontSize: 44,
      timeStart: Timeline.quoteStart,
      timeEnd: Timeline.quoteEnd,
      lines: [
        'This dream is for you',
        'So pay the price',
        'Make one dream come true',
        'You only live twice',
      ],
    ),

    AnimationParagraphState(
      alignment: const Alignment(0, -0.1),
      fontSize: 114,
      timeStart: Timeline.mainTitlesStart,
      timeEnd: Timeline.mainTitlesEnd,
      type: ParagraphAnimaType.titleSequence,
      lines: [
        'This dream is for you',
        'So pay the price',
        'Make one dream come true',
        'You only live twice',
      ],
    ),

    // ball animation
    AnimationBallState(),

    AnimaBlocks(
      AnimaBlocksState(
        timeStart: Timeline.blocksStart,
        timeEnd: Timeline.blocksEnd,
        blocksSequence: AnimaBlocksUtils.blocksSequenceFull,
        opacitySequence: AnimaBlocksUtils.opacitySequence,
        flipSequence: AnimaBlocksUtils.flipSequence,
        circles: true,
        colorSequence: AnimaBlocksUtils.colorSequence(Colors.cyan, Colors.pink),
        margin: 0,
      ),
    ),

    AnimaBlocks(
      AnimaBlocksState(
        timeStart: Timeline.blocks2Start,
        timeEnd: Timeline.blocks2End,
        reverse: true,
        downward: true,
        numColumns: 3,
        margin: 22,
        blocksSequence: AnimaBlocksUtils.blocksSequence,
        flipSequence: AnimaBlocksUtils.flipSequence,
      ),
    ),
  ];

  // =================================================

  Future<void> initialize(AnimationController controller) async {
    if (!isInitialized) {
      for (final item in _runables) {
        await item.initialize(controller);
      }

      isInitialized = true;
    }
  }

  void paint(Canvas canvas, Size size) {
    for (final item in _runables) {
      item.paint(canvas, size);
    }
  }
}
