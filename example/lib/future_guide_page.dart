import 'package:flutter/material.dart';
import 'package:flutter_intro/flutter_intro.dart';

class FutureGuidePage extends StatefulWidget {
  const FutureGuidePage({Key? key}) : super(key: key);

  @override
  State<FutureGuidePage> createState() => _FutureGuidePageState();
}

class _FutureGuidePageState extends State<FutureGuidePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IntroStepBuilder(
                /// 2nd guide
                order: 2,
                simpleText: '2nd guide',
                builder: (context, key) => Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      key: key,
                      width: 100,
                      child: const Placeholder(
                        fallbackHeight: 100,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              FutureBuilder(
                future: Future.delayed(
                    const Duration(
                      seconds: 2,
                    ), () {
                  return 'Good';
                }),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return IntroStepBuilder(
                      order: 3,
                      simpleText: "3rd guide",
                      builder: (context, key) => Placeholder(
                        key: key,
                        fallbackHeight: 100,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: IntroStepBuilder(
        /// 1st guide
        order: 1,
        simpleText: '1st guide',
        builder: (context, key) => FloatingActionButton(
          key: key,
          child: const Icon(
            Icons.play_arrow,
          ),
          onPressed: () {
            FlutterIntro.of(context)?.start();
          },
        ),
      ),
    );
  }
}
