import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_intro/flutter_intro.dart';

enum Mode {
  defaultTheme,
  customTheme,
  advancedTheme,
}

class GuidePage extends StatefulWidget {
  const GuidePage({
    Key? key,
    required this.title,
    required this.mode,
  }) : super(key: key);

  final String title;

  final Mode mode;

  @override
  _GuidePageState createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {
  late Intro intro;

  Widget customThemeWidgetBuilder(StepWidgetParams stepWidgetParams) {
    List<String> texts = [
      'Hello, I\'m Flutter Intro.',
      'I can help you quickly implement the Step By Step guide in the Flutter project.',
      'My usage is also very simple, you can quickly learn and use it through example and api documentation.',
      'In order to quickly implement the guidance, I also provide a set of out-of-the-box themes, I wish you all a happy use, goodbye!',
    ];
    return Padding(
      padding: const EdgeInsets.all(
        32,
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          Text(
            '${texts[stepWidgetParams.currentStepIndex]}【${stepWidgetParams.currentStepIndex + 1} / ${stepWidgetParams.stepCount}】',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: stepWidgetParams.onPrev,
                child: const Text(
                  'Prev',
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              ElevatedButton(
                onPressed: stepWidgetParams.onNext,
                child: const Text(
                  'Next',
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              ElevatedButton(
                onPressed: stepWidgetParams.onFinish,
                child: const Text(
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
    if (widget.mode == Mode.defaultTheme) {
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

    if (widget.mode == Mode.advancedTheme) {
      /// init Intro
      intro = Intro(
        stepCount: 4,
        maskClosable: false,
        onHighlightWidgetTap: (introStatus) {
          print(introStatus);
        },

        /// useAdvancedTheme
        widgetBuilder: StepWidgetBuilder.useAdvancedTheme(
          widgetBuilder: (params) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(.6),
              ),
              child: Column(
                children: [
                  Text(
                    '${params.currentStepIndex + 1}/${params.stepCount}',
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: params.onPrev,
                        child: const Text('Prev'),
                      ),
                      ElevatedButton(
                        onPressed: params.onNext,
                        child: const Text('Next'),
                      ),
                      ElevatedButton(
                        onPressed: params.onFinish,
                        child: const Text('Finish'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      );
      intro.setStepConfig(
        0,
        borderRadius: BorderRadius.circular(64),
      );
    }

    if (widget.mode == Mode.customTheme) {
      /// init Intro
      intro = Intro(
        stepCount: 4,

        maskClosable: true,

        /// implement widgetBuilder function
        widgetBuilder: customThemeWidgetBuilder,
      );
    }

    Timer(
      const Duration(
        milliseconds: 500,
      ),
      () {
        /// start the intro
        intro.start(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
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
                const SizedBox(
                  height: 16,
                ),
                Placeholder(
                  /// 3rd guide
                  key: intro.keys[2],
                  fallbackHeight: 100,
                ),
                const SizedBox(
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
          child: const Icon(
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
