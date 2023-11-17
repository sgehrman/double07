import 'package:double07/animation_state.dart';
import 'package:double07/deckr_animation_painter.dart';
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
  late Animation<double> textAnimation;
  final AnimationState _animationState = AnimationState();

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    );
    animation = Tween<double>(begin: 0, end: 1).animate(
      controller,
    );

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationState.reset();
        controller.reset();
        controller.forward();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });

    textAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(
          0.5,
          1,
          curve: Curves.ease,
        ),
      ),
    );

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            _animationState.update(animation.value, textAnimation.value);

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
