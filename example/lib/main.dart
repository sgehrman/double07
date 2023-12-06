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
              NewsCrawlParams(
                backColor: Colors.black,
                style: const TextStyle(fontSize: 30),
                height: 60,
                textColor: Colors.cyan,
                selectedTextColor: Colors.pink,
                duration: const Duration(seconds: 10),
                maxLength: 30,
                onTap: (link) {
                  print('tapped: ${link.url}');
                },
                links: [
                  NewsCrawlLink(
                    title:
                        'BBC news: Dog dies of herpes Dog dies of herpes Dog dies of herpes.',
                    url: 'http://www.bbc.com',
                  ),
                  NewsCrawlLink(
                    title:
                        'Tom Jones is dead Tom Jones is dead Tom Jones is dead.',
                    url: 'http://www.jones.com',
                  ),
                  NewsCrawlLink(
                    title:
                        'Hairy armpits are sexy Hairy armpits are sexy Hairy armpits are sexy',
                    url: 'http://www.armpits.com',
                  ),
                  NewsCrawlLink(
                    title:
                        'Sadat is king of SyriaS adat is king of Syria Sadat is king of Syria.',
                    url: 'http://www.syria.com',
                  ),
                  NewsCrawlLink(
                    title:
                        'Austrailia is super lame and gay Austrailia is super lame and gay.',
                    url: 'http://www.Austrailia.com',
                  ),
                  NewsCrawlLink(
                    title:
                        'Kat Kennedy is a bozo Kat Kennedy is a bozo Kat Kennedy is a bozo.',
                    url: 'http://www.Kennedy.com',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
