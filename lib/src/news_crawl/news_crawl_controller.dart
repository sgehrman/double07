import 'dart:async';
import 'dart:ui' as ui;

import 'package:dfc_flutter/dfc_flutter_web.dart';
import 'package:double07/src/animations/text/animated_letter.dart';
import 'package:double07/src/news_crawl/news_crawl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class NewsCrawlController {
  NewsCrawlController({
    required this.callback,
    required this.links,
    required this.fontSize,
    required this.duration,
  }) {
    _setup();
  }

  final void Function() callback;
  final Map<String, NewsCrawlWidgetController> _widgetControllers = {};
  final List<NewsCrawlLink> links;
  final double fontSize;
  final Duration duration;
  int _nextIndex = 0;

  List<NewsCrawlWidgetController> get widgetControllers =>
      _widgetControllers.values.toList();

  void dispose() {
    for (final c in _widgetControllers.values) {
      c.dispose();
    }
  }

  Future<void> _setup() async {
    await next();
  }

  // --------------------------------------------------------
  // called from widget controller

  void done(NewsCrawlWidgetController widgetController) {
    final result = _widgetControllers.remove(widgetController.id);

    if (result != null) {
      result.dispose();
    } else {
      print('not found?');
    }

    callback();
  }

  Future<void> next() async {
    if (links.isNotEmpty) {
      if (_nextIndex >= links.length) {
        _nextIndex = 0;
      }

      final id = Utils.uniqueFirestoreId();

      final c = NewsCrawlWidgetController(
        id: id,
        mainController: this,
        link: links[_nextIndex++],
        fontSize: fontSize,
        duration: duration,
      );

      await c.initialize();

      _widgetControllers[id] = c;

      callback();
    }
  }
}

// ============================================================

class NewsCrawlWidgetController extends ChangeNotifier
    implements TickerProvider {
  NewsCrawlWidgetController({
    required this.mainController,
    required this.link,
    required this.id,
    required this.fontSize,
    required this.duration,
  }) {
    _controller = AnimationController(
      vsync: this,
      duration: duration,
    );

    _controller.addStatusListener(_statusListener);
    _controller.addListener(_listener);
  }

  final String id;
  final NewsCrawlController mainController;
  final NewsCrawlLink link;
  final double fontSize;
  final Duration duration;
  Ticker? _ticker;

  ui.Image? _image;
  late final AnimationController _controller;
  bool isInitialized = false;
  bool _triggeredNext = false;

  @override
  void dispose() {
    _controller.stop();
    _controller.removeListener(_listener);
    _controller.removeStatusListener(_statusListener);
    _controller.dispose();

    _image?.dispose();

    _ticker?.dispose();

    super.dispose();
  }

  @override
  Ticker createTicker(TickerCallback onTick) {
    return _ticker ??= Ticker(onTick);
  }

  Future<void> initialize() async {
    _image = await AnimatedLetter.textImage(
      text: link.title,
      style: TextStyle(
        fontSize: fontSize,
      ),
      letterSpacing: 1,
    );

    isInitialized = true;
    unawaited(_controller.forward());
  }

  void _listener() {
    notifyListeners();
  }

  void _statusListener(status) {
    if (status == AnimationStatus.completed) {
      mainController.done(this);
    }
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
    if (isInitialized) {
      final imageWidth = _image!.width;
      const width = 1024 * 6;

      final result = widgetWidth - (_controller.value * width);

      if (!_triggeredNext) {
        if (result + imageWidth < (widgetWidth - 30)) {
          _triggeredNext = true;

          mainController.next();
        }
      }

      return result;
    }

    return 0;
  }
}
