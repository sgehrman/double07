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
    required this.params,
  }) {
    _setup();
  }

  final void Function() callback;
  final Map<String, NewsCrawlWidgetController> _widgetControllers = {};
  final NewsCrawlParams params;
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
    if (params.links.isNotEmpty) {
      if (_nextIndex >= params.links.length) {
        _nextIndex = 0;
      }

      final id = Utils.uniqueFirestoreId();

      final c = NewsCrawlWidgetController(
        id: id,
        mainController: this,
        link: params.links[_nextIndex++],
        params: params,
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
    required this.params,
  }) {
    _controller = AnimationController(
      vsync: this,
      duration: params.duration,
    );

    _controller.addStatusListener(_statusListener);
    _controller.addListener(_listener);
  }

  final String id;
  final NewsCrawlController mainController;
  final NewsCrawlLink link;
  final NewsCrawlParams params;
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

  String prepareTitle(String title) {
    if (title.isNotEmpty) {
      String str = link.title.toUpperCase().trim();

      // is last character a '.'?
      if (str.characters.last == '.') {
        str = str.substring(0, str.length - 1).trim();
      }

      // return if under maximum
      if (str.length <= params.maxLength) {
        return str;
      }

      final words = str.split(' ');

      final List<String> resultWords = [];
      int len = 0;
      for (final word in words) {
        resultWords.add(word);

        len += word.length;
        if (len >= params.maxLength) {
          break;
        }
      }

      // append ...
      final sentence = resultWords.join(' ');

      // could get to the last word and be barely over
      if (sentence == str) {
        return str;
      }

      // is last character a '.'
      if (sentence.characters.last == '.') {
        return '$sentence..';
      }

      return '$sentence...';
    }

    return '';
  }

  Future<void> initialize() async {
    _image = await AnimatedLetter.textImage(
      text: prepareTitle(link.title),
      style: params.style,
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
      const scrollWidth = 1024 * 6;

      final result = widgetWidth - (_controller.value * scrollWidth);

      if (!_triggeredNext) {
        if ((result + imageWidth) < (widgetWidth - 30)) {
          _triggeredNext = true;

          mainController.next();
        }
      }

      return result;
    }

    return 0;
  }
}
