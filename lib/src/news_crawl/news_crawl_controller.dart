import 'dart:async';
import 'dart:ui' as ui;

import 'package:dfc_flutter/dfc_flutter_web.dart';
import 'package:double07/src/animations/text/animated_letter.dart';
import 'package:double07/src/news_crawl/news_crawl.dart';
import 'package:flutter/material.dart';

class NewsCrawlController {
  NewsCrawlController({
    required this.callback,
    required this.params,
    required this.tickerProvider,
  }) {
    _setup();
  }

  final void Function() callback;
  final Map<String, NewsCrawlWidgetController> _widgetControllers = {};
  final NewsCrawlParams params;
  final TickerProvider tickerProvider;
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

    // hack: tab is inactive, so views don't draw and
    // getTranslateX is not called and last animation ends before calling next()
    // this restarts the animation
    if (widgetControllers.isEmpty) {
      next();
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

class NewsCrawlWidgetController extends ChangeNotifier {
  NewsCrawlWidgetController({
    required this.mainController,
    required this.link,
    required this.id,
    required this.params,
  }) {
    _controller = AnimationController(
      vsync: mainController.tickerProvider,
      duration: params.duration,
    );

    _controller.addStatusListener(_statusListener);
    _controller.addListener(_listener);
  }

  final String id;
  final NewsCrawlController mainController;
  final NewsCrawlLink link;
  final NewsCrawlParams params;
  final gapWidth = 40;

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

    super.dispose();
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
    final title = prepareTitle(link.title);

    if (title.isEmpty) {
      print(
        'NewsCrawlWidgetController title empty: "${link.title}", url: ${link.url}',
      );
    }

    _image = await AnimatedLetter.textImage(
      text: title,
      style: params.style,
      letterSpacing: 1,
      imageScale: 1,
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

  void pause({required bool pause}) {
    if (pause) {
      if (_controller.isAnimating) {
        _controller.stop();
      } else {
        print('already paused');
      }
    } else {
      if (!_controller.isAnimating) {
        _controller.forward();
      } else {
        print('already running');
      }
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
        if ((result + imageWidth) < (widgetWidth - gapWidth)) {
          _triggeredNext = true;

          mainController.next();
        }
      }

      return result;
    }

    return 0;
  }
}
