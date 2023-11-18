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
  late final List<Animation<double>> _textAnimations;
  late final List<Animation<double>> _textAnimations2;
  final AnimationState _animationState = AnimationState();

  // timing
  final double ballStart = 0;
  final double ballEnd = 1;

  final double textStart = 0.2;
  final double textEnd = 0.9;

  final double textStart2 = 0.4;
  final double textEnd2 = 1;

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

    _textAnimations = _buildTextAnimations(
      controller: _controller,
      text: _animationState.t1.text,
      tStart: textStart,
      tEnd: textEnd,
    );

    _textAnimations2 = _buildTextAnimations(
      controller: _controller,
      text: _animationState.t2.text,
      tStart: textStart2,
      tEnd: textEnd2,
    );

    await _animationState.initialize();

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

  static List<Animation<double>> _buildTextAnimations({
    required AnimationController controller,
    required String text,
    required double tStart,
    required double tEnd,
  }) {
    final List<Animation<double>> result = [];

    final len = text.length;

    final time = tEnd - tStart;
    double duration = time / len;
    const compress = 0.05;

    final spacer = duration * compress;
    duration = duration + (duration - spacer);

    for (int i = 0; i < len; i++) {
      final start = tStart + (i * spacer);
      final end = start + duration;

      result.add(
        Tween<double>(
          begin: 0,
          end: 1,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              start,
              end,
              curve: Curves.elasticInOut,
            ),
          ),
        ),
      );
    }

    return result;
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
                _textAnimations,
                _textAnimations2,
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
