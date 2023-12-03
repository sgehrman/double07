import 'package:double07/double07.dart';
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
      ),
      home: Scaffold(
        body: Column(
          children: [
            const Expanded(
              child: DeckrAnimation(
                autoplay: false,
              ),
            ),
            NewsCrawl(
              backColor: Colors.black,
              fontSize: 30,
              height: 60,
              textColor: Colors.cyan,
              selectedTextColor: Colors.pink,
              duration: const Duration(seconds: 10),
              onTap: (link) {
                print('tapped: ${link.url}');
              },
            ),
          ],
        ),
      ),
    );
  }
}
