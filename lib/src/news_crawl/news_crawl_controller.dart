import 'dart:async';
import 'dart:ui' as ui;

import 'package:dfc_flutter/dfc_flutter_web.dart';
import 'package:double07/src/animations/text/animated_letter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class NewsCrawlController implements TickerProvider {
  NewsCrawlController(this.callback) {
    _setup();
  }

  final void Function() callback;
  late final Ticker _ticker;
  bool isInitialized = false;
  final Map<String, NewsCrawlWidgetController> _widgetControllers = {};

  List<NewsCrawlWidgetController> get widgetControllers =>
      _widgetControllers.values.toList();

  @override
  Ticker createTicker(TickerCallback onTick) {
    return _ticker = Ticker(onTick);
  }

  void dispose() {
    for (final c in _widgetControllers.values) {
      c.dispose();
    }

    _ticker.dispose();
  }

  Future<void> _setup() async {
    final id = Utils.uniqueFirestoreId();

    final c = NewsCrawlWidgetController(
      id: id,
      tickerProvider: this,
    );

    await c.initialize();

    _widgetControllers[id] = c;

    isInitialized = true;

    callback();
  }
}

// ============================================================

class NewsCrawlWidgetController {
  NewsCrawlWidgetController({
    required this.tickerProvider,
    required this.id,
  });

  void Function()? _callback;
  final TickerProvider tickerProvider;
  final String id;

  ui.Image? _image;
  late final AnimationController _controller;
  late final Animation<double> _animation;
  bool isInitialized = false;

  void dispose() {
    _controller.dispose();
  }

  set callback(void Function()? c) => _callback = c;

  Future<void> initialize() async {
    _image = await AnimatedLetter.textImage(
      text: 'Test text image',
      style: const TextStyle(
        fontSize: 30,
      ),
      letterSpacing: 1,
    );

    _controller = AnimationController(
      vsync: tickerProvider,
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
      _callback?.call();
    });

    _animation = ReverseAnimation(
      _controller,
    );

    isInitialized = true;
    unawaited(_controller.forward());
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
