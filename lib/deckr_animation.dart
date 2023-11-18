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
  late final AnimationController _controller;
  late final Animation<double> _ballAnimation;
  final AnimationState _animationState = AnimationState();

  // timing
  final double ballStart = 0;
  final double ballEnd = 1;

  @override
  void initState() {
    super.initState();

    _setup();
  }

  Future<void> _setup() async {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
        _controller.forward();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });

    _buildBallAnimation();

    await _animationState.initialize(_controller);

    if (mounted) {
      setState(() {});
    }
    await _controller.forward();
  }

  // =================================================

  void _buildBallAnimation() {
    _ballAnimation = TweenSequence<double>(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0, end: 1),
          weight: 50,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0, end: 1),
          weight: 50,
        ),
      ],
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          ballStart,
          ballEnd,
        ),
      ),
    );
  }

  // =================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            if (_animationState.isInitialized) {
              _animationState.update(
                _ballAnimation.value,
              );

              return ColoredBox(
                color: Colors.black87,
                child: FittedBox(
                  child: CustomPaint(
                    size: const Size(2048, 1024),
                    painter: DeckrAnimationPainter(_animationState),
                  ),
                ),
              );
            }

            return const ColoredBox(
              color: Colors.black87,
            );
          },
        ),
      ),
    );
  }
}
