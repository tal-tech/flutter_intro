import 'package:flutter/material.dart';
import 'package:flutter_intro/flutter_intro.dart';
import 'package:intro/future_guide_page.dart';
import 'package:intro/guide_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterIntro(
      buttonTextBuilder: (order, current, total) {
        return current < total - 1 ? 'Next' : 'Finish';
      },
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const StartPage(),
      ),
    );
  }
}

class StartPage extends StatelessWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Intro'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              child: const Text('Start with useDefaultTheme'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const GuidePage(
                      title: 'Flutter Intro',
                      mode: Mode.defaultTheme,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              child: const Text('Start with useAdvancedTheme'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const GuidePage(
                      title: 'Flutter Intro',
                      mode: Mode.advancedTheme,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              child: const Text('Start with customTheme'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const GuidePage(
                      title: 'Flutter Intro',
                      mode: Mode.customTheme,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              child: const Text('Work with FutureBuilder'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const FutureGuidePage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
