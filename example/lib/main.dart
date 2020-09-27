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
      home: MyHomePage(title: 'Flutter Intro'),
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
          '你好呀，我是 Flutter Intro。',
          '我可以帮你在 Flutter 项目中快读实现 Step By Step 引导。',
          '我的用法也十分简单，你可以通过 example 和 api 文档快速掌握和使用。',
          '为了快速实现引导，我也默认提供了一套样式，开箱即用，祝大家使用愉快，再见！',
        ],
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SizedBox.expand(
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
                      fallbackHeight: 300,
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
    );
  }
}
