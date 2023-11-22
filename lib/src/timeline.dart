class Timeline {
  static int seconds = 50;
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
  static double ballEnd = durSecs(10);

  // ------------------------------------
  // main titles

  static double mainTitlesStart = durSecs(2);
  static double mainTitlesEnd = mainTitlesStart + durSecs(12);

  static double easterEggStart = durSecs(4);
  static double easterEggEnd = mainTitlesEnd;

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
