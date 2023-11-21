class AnimaBlocksState {
  AnimaBlocksState({
    required this.timeStart,
    required this.timeEnd,
    this.reverse = false,
    this.downward = false,
    this.numColumns = 6,
  });

  final double timeStart;
  final double timeEnd;
  final bool reverse;
  final bool downward;
  final int numColumns;
}
