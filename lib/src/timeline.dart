class Timeline {
  static Duration runDuration = const Duration(seconds: 18);

  // ------------------------------------
  // main titles
  static double mainTitlesStart = 0;
  static double mainTitlesEnd = 0.2;

  static double easterEggStart = 0.1;
  static double easterEggEnd = mainTitlesEnd;

  // ------------------------------------
  // double07 ball

  static double ballStart = easterEggEnd;
  static double ballEnd = ballStart + 0.2;

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
