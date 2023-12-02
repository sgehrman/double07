import 'dart:async';
import 'dart:ui' as ui;

import 'package:double07/src/animations/text/animated_letter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class NewsCrawlController implements TickerProvider {
  NewsCrawlController(this.callback) {
    _setup();
  }

  final void Function() callback;
  ui.Image? _image;
  late final Ticker _ticker;
  late final AnimationController _controller;
  late final Animation<double> _animation;
  bool isInitialized = false;

  @override
  Ticker createTicker(TickerCallback onTick) {
    return _ticker = Ticker(onTick);
  }

  void dispose() {
    _ticker.dispose();
  }

  Future<void> _setup() async {
    _image = await AnimatedLetter.textImage(
      text: 'Test text image',
      style: const TextStyle(
        fontSize: 30,
      ),
      letterSpacing: 1,
    );

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });

    _controller.addListener(() {
      callback();
    });

    _animation = ReverseAnimation(
      _controller,
    );

    isInitialized = true;
    await _controller.forward();
  }

  void pause() {
    if (_controller.isAnimating) {
      _controller.stop();
    } else {
      _controller.forward();
    }
  }

  ui.Image? get image => _image;

  double getTranslateX(
    double widgetWidth,
  ) {
    if (_image != null) {
      final imageWidth = _image!.width;
      final width = widgetWidth + imageWidth;

      return (_animation.value * width) - imageWidth;
    }

    return 0;
  }
}
