import 'package:double07/animated_text_info.dart';
import 'package:double07/animation_text_state.dart';
import 'package:flutter/material.dart';

class DeckrAnimationPainterText {
  static void paintText(
    Canvas canvas,
    Size size,
    AnimationTextState textState,
  ) {
    for (int i = 0; i < textState.textImages.length; i++) {
      _paintText(
        canvas: canvas,
        size: size,
        textImage: textState.textImages[i],
        textAnima: textState.textAnimations[i],
      );
    }
  }

  static void _paintText({
    required Canvas canvas,
    required Size size,
    required AnimatedTextInfo textImage,
    required Animation<double> textAnima,
  }) {
    if (textAnima.value > 0) {
      final rect = Offset.zero & size;
      // const multiplier = math.max(1, (1 - animationState.textAnimValue) * 122);

      final tSize = textImage.painter.size;

      const startAlignment = Alignment(-0.5, -5);
      const endAlignment = Alignment(-0.5, -0.5);

      final alignment = Alignment.lerp(
            startAlignment,
            endAlignment,
            textAnima.value,
          ) ??
          Alignment.center;

      Rect destRect = alignment.inscribe(
        Size(
          textImage.wordSize.width,
          textImage.wordSize.height,
        ),
        rect,
      );

      destRect = textImage.alignment.inscribe(
        Size(
          tSize.width,
          tSize.height,
        ),
        destRect,
      );

      paintImage(
        canvas: canvas,
        rect: destRect,
        fit: BoxFit.fill,
        image: textImage.image,
        opacity: 0.1,
        isAntiAlias: true,
        filterQuality: FilterQuality.high,
      );
    }
  }
}
