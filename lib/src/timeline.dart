class Timeline {
  static int seconds = 70;
  static Duration runDuration = Duration(seconds: seconds);

  static double durSecs(int secs) {
    return secs / seconds;
  }

  static double durMillis(int milliseconds) {
    return milliseconds / (seconds * 1000);
  }

  // ------------------------------------
  // double07 ball

  static double ballStart = 0;
  static double ballEnd = durSecs(15);

  // ------------------------------------
  // main titles

  static double mainTitlesStart = durSecs(5);
  static double mainTitlesEnd = mainTitlesStart + durSecs(12);

  static double easterEggStart = durSecs(4);
  static double easterEggEnd = easterEggStart + durSecs(4);

  // ------------------------------------
  // binoculars

  static double binocularsStart = mainTitlesEnd;
  static double binocularsEnd = binocularsStart + durSecs(10);

  static double quoteStart = binocularsStart + durSecs(3);
  static double quoteEnd = quoteStart + durSecs(4);

  // ------------------------------------
  // reviews

  static const int _reviewSecs = 8;

  static double reviewsStart = binocularsEnd;
  static double reviewsEnd = reviewsStart + durSecs(3);

  static double hendersonStart = reviewsEnd;
  static double hendersonEnd = hendersonStart + durSecs(_reviewSecs);
  static double hendersonTextStart = hendersonStart + durSecs(1);
  static double hendersonTextEnd = hendersonEnd;

  static double largoStart = hendersonEnd;
  static double largoEnd = largoStart + durSecs(_reviewSecs);
  static double largoTextStart = largoStart + durSecs(1);
  static double largoTextEnd = largoEnd;

  static double dominoStart = largoEnd;
  static double dominoEnd = dominoStart + durSecs(_reviewSecs);
  static double dominoTextStart = dominoStart + durSecs(1);
  static double dominoTextEnd = dominoEnd;

  // ------------------------------------
  // blocks

  static double scaledImageStart = dominoEnd;
  static double scaledImageEnd = scaledImageStart + durSecs(10);

  static double blocksStart = dominoEnd;
  static double blocksEnd = blocksStart + durSecs(5);

  static double blocks2Start = blocksEnd;
  static double blocks2End = blocks2Start + durSecs(5);

  // ------------------------------------
  // credits

  static double creditsStart = blocks2End;
  static double creditsEnd = creditsStart + durSecs(4);

  // ------------------------------------
  // xxx

  static double deckrLogoStart = ballEnd;
  static double deckrLogoEnd = deckrLogoStart + durSecs(3);
}
