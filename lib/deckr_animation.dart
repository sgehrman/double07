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
  late AnimationController _controller;
  late Animation<double> _ballAnimation;
  late Animation<double> _textAnimation;
  final AnimationState _animationState = AnimationState();

  @override
  void initState() {
    super.initState();

    _setup();
  }

  Future<void> _setup() async {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationState.reset();
        _controller.reset();
        _controller.forward();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });

    _buildBallAnimation();
    _buildTextAnimation();

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
    ).animate(_controller);
  }

  // =================================================

  void _buildTextAnimation() {
    _textAnimation = TweenSequence<double>(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0, end: 1),
          weight: 100,
        ),
        // TweenSequenceItem<double>(
        //   tween: Tween<double>(begin: 1, end: 0),
        //   weight: 25,
        // ),
        // TweenSequenceItem<double>(
        //   tween: Tween<double>(begin: 0, end: 1),
        //   weight: 25,
        // ),
        // TweenSequenceItem<double>(
        //   tween: Tween<double>(begin: 1, end: 0),
        //   weight: 25,
        // ),
      ],
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0,
          0.4,
          // curve: Curves.linear,
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
                _textAnimation.value,
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

            _animationState.update(_ballAnimation.value, _textAnimation.value);

            return const ColoredBox(
              color: Colors.black87,
            );
          },
        ),
      ),
    );
  }
}
