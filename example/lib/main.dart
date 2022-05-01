import 'package:flutter/material.dart';
import 'package:flutter_intro/flutter_intro.dart';
import 'package:intro/advanced_usage.dart';
import 'package:intro/demo_usage.dart';
import 'package:intro/simple_usage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const StartPage(),
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => Intro(
                      padding: EdgeInsets.zero,
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      maskColor: const Color.fromRGBO(0, 0, 0, .6),
                      child: const DemoUsage(),
                    ),
                  ),
                );
              },
              child: const Text('Demo'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => Intro(
                      buttonTextBuilder: (order) =>
                          order == 3 ? 'Custom Button Text' : 'Next',
                      child: const SimpleUsage(),
                    ),
                  ),
                );
              },
              child: const Text('Simple Usage'),
            ),
            ElevatedButton(
              child: const Text('Advanced Usage'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => Intro(
                      maskClosable: true,
                      child: const AdvancedUsage(),
                    ),
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
