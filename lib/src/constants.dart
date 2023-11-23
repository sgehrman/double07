const kAssets = 'packages/double07/assets';

// audio files need the assets/ prefix to load in the html element
const kAudioAssets = 'assets/packages/double07/assets';

class SequenceWeights {
  const SequenceWeights()
      : start = 10,
        hold = 80,
        end = 10;

  const SequenceWeights.custom(this.start, this.hold, this.end);

  const SequenceWeights.front()
      : start = 40,
        hold = 58,
        end = 2;

  const SequenceWeights.frontEnd()
      : start = 40,
        hold = 50,
        end = 10;

  const SequenceWeights.end()
      : start = 2,
        hold = 58,
        end = 40;

  const SequenceWeights.equal()
      : start = 1,
        hold = 1,
        end = 1;

  const SequenceWeights.noHold()
      : start = 48,
        hold = 2,
        end = 48;

  final double start;
  final double hold;
  final double end;

  @override
  String toString() {
    return 'SequenceWeights - start: $start, hold: $hold, end: $end';
  }
}
