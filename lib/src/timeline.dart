class Timeline {
  static int seconds = 50;
  static Duration runDuration = Duration(seconds: seconds);

  static double durSeconds(int secs) {
    return secs / seconds;
  }

  // ------------------------------------
  // main titles
  static double mainTitlesStart = 0;
  static double mainTitlesEnd = durSeconds(12);

  static double easterEggStart = durSeconds(2);
  static double easterEggEnd = mainTitlesEnd;

  // ------------------------------------
  // double07 ball

  static double ballStart = mainTitlesEnd;
  static double ballEnd = ballStart + durSeconds(4);

  // ------------------------------------
  // reviews

  static double textStart = ballEnd;
  static double textEnd = textStart + 0.2;

  static double quoteStart = 0.1;
  static double quoteEnd = 1;

  // ==============================
  // blocks

  static double blocksStart = 0.2;
  static double blocksEnd = 0.4;

  static double blocks2Start = 0.4;
  static double blocks2End = 0.6;

  // ==============================
  // backgounds

  static double hendersonStart = 0;
  static double hendersonEnd = 0.3;
  static double hendersonTextStart = hendersonStart;
  static double hendersonTextEnd = hendersonEnd;

  static double largoStart = hendersonEnd;
  static double largoEnd = 0.7;
  static double largoTextStart = largoStart;
  static double largoTextEnd = largoEnd;

  static double dominoStart = largoEnd;
  static double dominoEnd = 1;
  static double dominoTextStart = dominoStart;
  static double dominoTextEnd = dominoEnd;
}
