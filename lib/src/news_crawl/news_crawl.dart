import 'dart:async';

import 'package:double07/src/animations/text/letter_painter.dart';
import 'package:double07/src/news_crawl/news_crawl_painter.dart';
import 'package:double07/src/news_crawl/news_crawl_sequence.dart';
import 'package:flutter/material.dart';

class NewsCrawl extends StatefulWidget {
  const NewsCrawl({
    required this.autoplay,
  });

  final bool autoplay;

  @override
  State<NewsCrawl> createState() => _NewsCrawlState();
}

class _NewsCrawlState extends State<NewsCrawl>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final NewsCrawlSequence _animationState = NewsCrawlSequence();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    _setup();
  }

  @override
  void dispose() {
    _controller.dispose();

    // free up cached images
    LetterPainterCache().clear();

    super.dispose();
  }

  Future<void> _setup() async {
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // dd
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });

    await _animationState.initialize(_controller);

    if (mounted) {
      setState(() {});
    }
    await _controller.forward();
  }

  // =================================================

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // fff
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          if (_animationState.isInitialized) {
            return CustomPaint(
              painter: NewsCrawlPainter(_animationState),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
