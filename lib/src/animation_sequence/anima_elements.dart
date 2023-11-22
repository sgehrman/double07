import 'package:double07/src/animation_sequence/animation_sequence.dart';
import 'package:double07/src/animations/anima_image/anima_image.dart';
import 'package:double07/src/animations/anima_image/anima_image_state.dart';
import 'package:double07/src/animations/animation_ball_state.dart';
import 'package:double07/src/animations/backgrounds/anima_background.dart';
import 'package:double07/src/animations/backgrounds/anima_background_state.dart';
import 'package:double07/src/animations/shapes/anima_blocks.dart';
import 'package:double07/src/animations/shapes/anima_blocks_state.dart';
import 'package:double07/src/animations/shapes/anima_blocks_utils.dart';
import 'package:double07/src/animations/text/anima_paragraph.dart';
import 'package:double07/src/animations/text/anima_text.dart';
import 'package:double07/src/animations/text/anima_text_state.dart';
import 'package:double07/src/constants.dart';
import 'package:double07/src/timeline.dart';
import 'package:flutter/material.dart';

class AnimaElements {
  static const double kTitleFontSize = 116;
  static const double kSmallFontSize = 30;
  static const double kLargeFontSize = 42;

  static RunableAnimation dominoQuote() {
    return AnimaParagraph(
      alignment: const Alignment(-0.12, 0.65),
      timeStart: Timeline.dominoTextStart,
      timeEnd: Timeline.dominoTextEnd,
      animateFrom: 0,
      lines: [
        AnimaTextLine(
          text: 'My darlings,',
          fontSize: kSmallFontSize,
        ),
        AnimaTextLine(
          text: 'I adore using Deckr after',
          fontSize: kSmallFontSize,
        ),
        AnimaTextLine(
          text: 'diving in the Bahamas.',
          fontSize: kSmallFontSize,
        ),
        AnimaTextLine.blank(),
        AnimaTextLine(
          text: '- Domino',
          fontSize: kLargeFontSize,
          color: Colors.cyan,
        ),
      ],
    );
  }

  static RunableAnimation largoQuote() {
    return AnimaParagraph(
      alignment: const Alignment(0.7, 0.75),
      timeStart: Timeline.largoTextStart,
      timeEnd: Timeline.largoTextEnd,
      animateFrom: 0,
      lines: [
        AnimaTextLine(
          text: 'All members of SPECTER',
          fontSize: kSmallFontSize,
        ),
        AnimaTextLine(
          text: 'are required to use Deckr.',
          fontSize: kSmallFontSize,
        ),
        AnimaTextLine.blank(),
        AnimaTextLine(
          text: '- Emilio Largo',
          fontSize: kLargeFontSize,
          color: Colors.cyan,
        ),
      ],
    );
  }

  static RunableAnimation hendersonQuote() {
    return AnimaParagraph(
      alignment: const Alignment(-0.3, 0.6),
      timeStart: Timeline.hendersonTextStart,
      timeEnd: Timeline.hendersonTextEnd,
      animateFrom: 0,
      lines: [
        AnimaTextLine(
          text: 'A friend of mine at the Russian Embassy',
          fontSize: kSmallFontSize,
        ),
        AnimaTextLine(
          text: 'Recommended I use Deckr among other things.',
          fontSize: kSmallFontSize,
        ),
        AnimaTextLine.blank(),
        AnimaTextLine(
          text: '- Mr. Henderson',
          fontSize: kLargeFontSize,
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
          fontSize: kSmallFontSize,
        ),
        AnimaTextLine(
          text: 'So pay the price',
          fontSize: kSmallFontSize,
        ),
        AnimaTextLine(
          text: 'Make one dream come true',
          fontSize: kLargeFontSize,
        ),
        AnimaTextLine(
          text: 'You only live twice',
          fontSize: kLargeFontSize,
        ),
      ],
    );
  }

  static RunableAnimation introTitles() {
    return AnimaParagraph(
      alignment: const Alignment(0, -0.1),
      timeStart: Timeline.mainTitlesStart,
      timeEnd: Timeline.mainTitlesEnd,
      type: ParagraphAnimaType.titleSequence,
      lines: [
        AnimaTextLine(
          text: 'This dream is for you',
          fontSize: kTitleFontSize,
        ),
        AnimaTextLine(
          text: 'So pay the price',
          fontSize: kTitleFontSize,
        ),
        AnimaTextLine(
          text: 'Make one dream come true',
          fontSize: kTitleFontSize,
        ),
        AnimaTextLine(
          text: 'You only live twice',
          fontSize: kTitleFontSize,
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

  static RunableAnimation easterEgg() {
    return AnimaImage(
      AnimaImageState(
        imageAsset: '$kAssets/images/egg.png',
        size: const Size(400, 400),
        timeStart: 0.1,
        timeEnd: 0.4,
        alignments: [
          Alignment.topCenter,
          Alignment.center,
          Alignment.topCenter,
        ],
      ),
    );
  }

  static RunableAnimation double07Ball() {
    return AnimationBallState();
  }
}
