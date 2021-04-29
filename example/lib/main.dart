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
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              child: Text('Start with useDefaultTheme'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => MyHomePage(
                      title: 'Flutter Intro',
                      mode: Mode.defaultTheme,
                    ),
                  ),
                );
              },
            ),
            SizedBox(
              height: 16,
            ),
            ElevatedButton(
              child: Text('Start with customTheme'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => MyHomePage(
                      title: 'Flutter Intro',
                      mode: Mode.customTheme,
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

enum Mode {
  defaultTheme,
  customTheme,
}

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key key,
    this.title,
    this.mode,
  }) : super(key: key);

  final String title;

  final Mode mode;

  @override
  _MyHomePageState createState() => _MyHomePageState(
        mode: mode,
      );
}

class _MyHomePageState extends State<MyHomePage> {
  Intro intro;

  _MyHomePageState({
    Mode mode,
  }) {
    if (mode == Mode.defaultTheme) {
      /// init Intro
      intro = Intro(
        stepCount: 4,
        maskClosable: true,
        onHighlightWidgetTap: (introStatus) {
          print(introStatus);
        },

        /// use defaultTheme
        widgetBuilder: StepWidgetBuilder.useDefaultTheme(
          texts: [
            'Hello, I\'m Flutter Intro.',
            'I can help you quickly implement the Step By Step guide in the Flutter project.',
            'My usage is also very simple, you can quickly learn and use it through example and api documentation.',
            'In order to quickly implement the guidance, I also provide a set of out-of-the-box themes, I wish you all a happy use, goodbye!',
          ],
          buttonTextBuilder: (currPage, totalPage) {
            return currPage < totalPage - 1 ? 'Next' : 'Finish';
          },
        ),
      );
      intro.setStepConfig(
        0,
        borderRadius: BorderRadius.circular(64),
      );
    }
    if (mode == Mode.customTheme) {
      /// init Intro
      intro = Intro(
        stepCount: 4,

        maskClosable: true,

        /// implement widgetBuilder function
        widgetBuilder: customThemeWidgetBuilder,
      );
    }
  }

  Widget customThemeWidgetBuilder(StepWidgetParams stepWidgetParams) {
    List<String> texts = [
      'Hello, I\'m Flutter Intro.',
      'I can help you quickly implement the Step By Step guide in the Flutter project.',
      'My usage is also very simple, you can quickly learn and use it through example and api documentation.',
      'In order to quickly implement the guidance, I also provide a set of out-of-the-box themes, I wish you all a happy use, goodbye!',
    ];
    return Padding(
      padding: EdgeInsets.all(
        32,
      ),
      child: Column(
        children: [
          SizedBox(
            height: 40,
          ),
          Text(
            '${texts[stepWidgetParams.currentStepIndex]}【${stepWidgetParams.currentStepIndex + 1} / ${stepWidgetParams.stepCount}】',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: stepWidgetParams.onPrev,
                child: Text(
                  'Prev',
                ),
              ),
              SizedBox(
                width: 16,
              ),
              ElevatedButton(
                onPressed: stepWidgetParams.onNext,
                child: Text(
                  'Next',
                ),
              ),
              SizedBox(
                width: 16,
              ),
              ElevatedButton(
                onPressed: stepWidgetParams.onFinish,
                child: Text(
                  'Finish',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Timer(
      Duration(
        milliseconds: 500,
      ),
      () {
        /// start the intro
        intro.start(context);
      },
    );
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
        // sometimes you need get current status
        IntroStatus introStatus = intro.getStatus();
        if (introStatus.isOpen) {
          // destroy guide page when tap back key
          intro.dispose();
          return false;
        }
        return true;
      },
    );
  }
}
