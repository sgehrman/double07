# double07

Flutter animation experiments

1. typewriter sounds
2. how sync sound with animations?
3. binocular view with focus?

https://dev.to/heyhey1028/flutter-mastering-animation-4-the-confusing-parts-of-animations-3cp3

```
 final timing = AnimaTiming.group(
      start: 55,
      end: 85,
      groupEnd: 1000,
    );

    final s = timing.startWeight * 1000;
    print(s);
    final e = timing.endWeight * 1000;
    print(e);
    final h = timing.holdWeight * 1000;
    print(h);
    print(h + s + e);
```