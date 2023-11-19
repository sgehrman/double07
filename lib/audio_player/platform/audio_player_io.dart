mixin AudioPlayerMixin {
  void platformDispose() {}

  void platformPlay() {}

  void platformPause() {}

  void platformOpen({
    required String path,
  }) {}
}
