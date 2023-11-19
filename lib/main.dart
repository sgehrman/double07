import 'package:double07/src/audio_player/simple_mp3_player.dart';
import 'package:double07/src/deckr_animation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: SizedBox.expand(
          child: Stack(
            children: [
              DeckrAnimation(),
              SimpleMP3Player(),
            ],
          ),
        ),
      ),
    );
  }
}
