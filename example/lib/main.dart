import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_intro/flutter_intro.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StartPage(),
    );
  }
}

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Intro'),
      ),
      body: Container(
        child: Center(
          child: RaisedButton(
            child: Text('Start'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => MyHomePage(
                    title: 'Flutter Intro',
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Intro intro;

  _MyHomePageState() {
    /// init Intro
    intro = Intro(
      stepCount: 4,

      /// use defaultTheme, or you can implement widgetBuilder function yourself
      widgetBuilder: StepWidgetBuilder.useDefaultTheme(
        texts: [
          'Hello, I\'m Flutter Intro.',
          'I can help you quickly implement the Step By Step guide in the Flutter project.',
          'My usage is also very simple, you can quickly learn and use it through example and api documentation.',
          'In order to quickly implement the guidance, I also provide a set of out-of-the-box themes, I wish you all a happy use, goodbye!',
        ],
        buttonTextBuilder: (curr, total) {
          return curr < total - 1 ? 'Next' : 'Finish';
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(microseconds: 0), () {
      /// start the intro
      intro.start(context);
    });
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 100,
                  child: Placeholder(
                    /// 2nd guide
                    key: intro.keys[1],
                    fallbackHeight: 100,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Placeholder(
                  /// 3rd guide
                  key: intro.keys[2],
                  fallbackHeight: 100,
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 100,
                      child: Placeholder(
                        /// 4th guide
                        key: intro.keys[3],
                        fallbackHeight: 100,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          /// 1st guide
          key: intro.keys[0],
          child: Icon(
            Icons.play_arrow,
          ),
          onPressed: () {
            intro.start(context);
          },
        ),
      ),
      onWillPop: () async {
        // destroy guide page when tap back key
        intro.dispose();
        return true;
      },
    );
  }
}
