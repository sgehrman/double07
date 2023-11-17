import 'package:flutter/material.dart';

class DeckrAnimation extends StatefulWidget {
  const DeckrAnimation({super.key});

  @override
  State<DeckrAnimation> createState() => _DeckrAnimationState();
}

class _DeckrAnimationState extends State<DeckrAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  final AnimationState _animationState = AnimationState();

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    );
    animation = Tween<double>(begin: 0, end: 1).animate(controller);

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reset();
        controller.forward();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            _animationState.update(animation.value);

            return ColoredBox(
              color: Colors.black87,
              child: FittedBox(
                child: CustomPaint(
                  size: const Size(2048, 1024),
                  painter: DeckrAnimationPainter(_animationState),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ================================================

class DeckrAnimationPainter extends CustomPainter {
  DeckrAnimationPainter(this.animationState);

  final AnimationState animationState;

  @override
  void paint(Canvas canvas, Size size) {
    const double ballRadius = 100;
    final rect = Offset.zero & size;
    const ballColor = Colors.white;
    final ballPaint = Paint()..color = ballColor;
    final backPaint = Paint()..color = Colors.black;

    canvas.drawRect(rect, backPaint);

    canvas.drawCircle(
      Offset(
        size.width * animationState.animationValue,
        size.height / 2,
      ),
      ballRadius,
      ballPaint,
    );

    // fade ball
    if (animationState.fadeBallPosition != -1) {
      final ballFadePaint = Paint()
        ..color = ballColor.withOpacity(animationState.fadeBallOpacity);

      canvas.drawCircle(
        Offset(
          size.width * animationState.fadeBallPosition,
          size.height / 2,
        ),
        ballRadius,
        ballFadePaint,
      );
    }

    if (animationState.fadeBallPosition2 != -1) {
      final ballFadePaint = Paint()
        ..color = ballColor.withOpacity(animationState.fadeBallOpacity2);

      canvas.drawCircle(
        Offset(
          size.width * animationState.fadeBallPosition2,
          size.height / 2,
        ),
        ballRadius,
        ballFadePaint,
      );
    }

    animationState.textPainter.paint(
      canvas,
      size.topCenter(
        -animationState.textPainter.size.topCenter(
          -const Offset(0, 12),
        ),
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

// ================================================

class AnimationState {
  AnimationState() {
    const TextStyle style = TextStyle(
      color: Colors.white54,
      // fontWeight: FontWeight.bold,
      fontSize: 64.0,
    );

    TextSpan span12 = TextSpan(style: style, text: 'Deckr'.toUpperCase());
    textPainter = TextPainter(
      text: span12,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
  }

  late TextPainter textPainter;

  double animationValue = 0;

  double fadeBallPosition = -1;
  double fadeBallOpacity = 0;

  double fadeBallPosition2 = -1;
  double fadeBallOpacity2 = 0;

  int lastV = -1;

  void update(double value) {
    animationValue = value;

    final int v = (value * 100).round();

    if (v != lastV && (v % 15) == 0) {
      lastV = v;

      if (fadeBallPosition == -1) {
        fadeBallOpacity = 1;
        fadeBallPosition = value;
      } else if (fadeBallPosition2 == -1) {
        fadeBallOpacity2 = 1;
        fadeBallPosition2 = value;
      }
    }

    if (fadeBallPosition != -1) {
      fadeBallOpacity -= .015;

      if (fadeBallOpacity < 0) {
        fadeBallPosition = -1;
      }
    }

    if (fadeBallPosition2 != -1) {
      fadeBallOpacity2 -= .015;

      if (fadeBallOpacity2 < 0) {
        fadeBallPosition2 = -1;
      }
    }
  }
}
