import 'package:double07/src/animation_sequence/animation_sequence.dart';
import 'package:double07/src/animations/backgrounds/anima_background.dart';
import 'package:double07/src/animations/backgrounds/anima_background_state.dart';
import 'package:double07/src/animations/shapes/anima_blocks.dart';
import 'package:double07/src/animations/shapes/anima_blocks_state.dart';
import 'package:double07/src/animations/shapes/anima_blocks_utils.dart';
import 'package:double07/src/animations/text/anima_paragraph.dart';
import 'package:double07/src/animations/text/anima_text.dart';
import 'package:double07/src/animations/text/anima_text_state.dart';
import 'package:double07/src/timeline.dart';
import 'package:double07/src/utils.dart';
import 'package:flutter/material.dart';

class AnimaElements {
  static RunableAnimation dominoQuote() {
    return AnimaParagraph(
      alignment: const Alignment(-0.12, 0.7),
      timeStart: Timeline.dominoTextStart,
      timeEnd: Timeline.dominoTextEnd,
      animateFrom: 0,
      lines: [
        AnimaTextLine(
          text: 'My darlings,',
          fontSize: 32,
          color: Colors.white,
        ),
        AnimaTextLine(
          text: 'I adore using Deckr after',
          fontSize: 32,
          color: Colors.white,
        ),
        AnimaTextLine(
          text: 'diving in the Bahamas.',
          fontSize: 32,
          color: Colors.white,
        ),
        AnimaTextLine(
          text: '- Domino',
          fontSize: 44,
          color: Colors.cyan,
        ),
      ],
    );
  }

  static RunableAnimation largoQuote() {
    return AnimaParagraph(
      alignment: const Alignment(0.6, 0.8),
      timeStart: Timeline.largoTextStart,
      timeEnd: Timeline.largoTextEnd,
      animateFrom: 0,
      lines: [
        AnimaTextLine(
          text: 'All members of SPECTER',
          fontSize: 32,
          color: Colors.white,
        ),
        AnimaTextLine(
          text: 'Are required to use Deckr.',
          fontSize: 32,
          color: Colors.white,
        ),
        AnimaTextLine(
          text: '- Emilio Largo',
          fontSize: 44,
          color: Colors.cyan,
        ),
      ],
    );
  }

  static RunableAnimation hendersonQuote() {
    return AnimaParagraph(
      alignment: const Alignment(-0.2, 0.6),
      timeStart: Timeline.hendersonTextStart,
      timeEnd: Timeline.hendersonTextEnd,
      animateFrom: 0,
      lines: [
        AnimaTextLine(
          text: 'A friend of mine at the Russian Embassy',
          fontSize: 32,
          color: Colors.white,
        ),
        AnimaTextLine(
          text: 'Recommended I use Deckr among other things.',
          fontSize: 32,
          color: Colors.white,
        ),
        AnimaTextLine(
          text: '- Mr. Henderson',
          fontSize: 44,
          color: Colors.cyan,
        ),
      ],
    );
  }

  static RunableAnimation randomQuote() {
    return AnimaParagraph(
      alignment: const Alignment(0.8, -0.8),
      timeStart: Timeline.quoteStart,
      timeEnd: Timeline.quoteEnd,
      animateFrom: 0,
      lines: [
        AnimaTextLine(
          text: 'This dream is for you',
          fontSize: 32,
          color: Colors.white,
        ),
        AnimaTextLine(
          text: 'So pay the price',
          fontSize: 32,
          color: Colors.white,
        ),
        AnimaTextLine(
          text: 'Make one dream come true',
          fontSize: 44,
          color: Colors.white,
        ),
        AnimaTextLine(
          text: 'You only live twice',
          fontSize: 44,
          color: Colors.white,
        ),
      ],
    );
  }

  static RunableAnimation introTitles() {
    const double fontSize = 114;

    return AnimaParagraph(
      alignment: const Alignment(0, -0.1),
      timeStart: Timeline.mainTitlesStart,
      timeEnd: Timeline.mainTitlesEnd,
      type: ParagraphAnimaType.titleSequence,
      lines: [
        AnimaTextLine(
          text: 'This dream is for you',
          fontSize: fontSize,
          color: Colors.white,
        ),
        AnimaTextLine(
          text: 'So pay the price',
          fontSize: fontSize,
          color: Colors.white,
        ),
        AnimaTextLine(
          text: 'Make one dream come true',
          fontSize: fontSize,
          color: Colors.white,
        ),
        AnimaTextLine(
          text: 'You only live twice',
          fontSize: fontSize,
          color: Colors.white,
        ),
      ],
    );
  }

  static List<RunableAnimation> blocks() {
    return [
      AnimaBlocks(
        AnimaBlocksState(
          timeStart: Timeline.blocksStart,
          timeEnd: Timeline.blocksEnd,
          blocksSequence: AnimaBlocksUtils.blocksSequenceFull,
          opacitySequence: AnimaBlocksUtils.opacitySequence,
          flipSequence: AnimaBlocksUtils.flipSequence,
          circles: true,
          colorSequence:
              AnimaBlocksUtils.colorSequence(Colors.cyan, Colors.pink),
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
  }

  static List<RunableAnimation> backgrounds() {
    return [
      // AnimaBackground(
      //   AnimaBackgroundState(
      //     imageAsset: '$kAssets/images/henderson.png',
      //     gradientAlignment: const Alignment(-0.25, -0.3),
      //     timeStart: 0,
      //     timeEnd: 1,
      //     mode: AnimaBackgroundMode.zoomIn,
      //   ),
      // ),

      AnimaBackground(
        AnimaBackgroundState(
          imageAsset: '$kAssets/images/henderson.png',
          gradientAlignment: const Alignment(-0.25, -0.3),
          timeStart: Timeline.hendersonStart,
          timeEnd: Timeline.hendersonEnd,
        ),
      ),
      AnimaBackground(
        AnimaBackgroundState(
          imageAsset: '$kAssets/images/largo.jpg',
          gradientAlignment: const Alignment(0.7, -0.1),
          timeStart: Timeline.largoStart,
          timeEnd: Timeline.largoEnd,
        ),
      ),
      AnimaBackground(
        AnimaBackgroundState(
          imageAsset: '$kAssets/images/domino.jpg',
          gradientAlignment: const Alignment(-0.1, -0.2),
          timeStart: Timeline.dominoStart,
          timeEnd: Timeline.dominoEnd,
        ),
      ),
    ];
  }

  static RunableAnimation deckrLogo() {
    return AnimaText(
      AnimaTextState(
        line: AnimaTextLine(
          text: 'Deckr'.toUpperCase(),
          fontSize: 64,
          bold: true,
          color: Colors.white,
        ),
        alignments: [
          const Alignment(-0.8, -2),
          const Alignment(-0.8, -0.8),
        ],
        timeStart: Timeline.textStart,
        timeEnd: Timeline.textEnd,
      ),
    );
  }
}
