import 'package:flutter/material.dart';
import 'package:flutter_intro/flutter_intro.dart';

class SimpleUsage extends StatelessWidget {
  const SimpleUsage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(
            16,
          ),
          child: Center(
            child: Column(
              children: [
                IntroStepBuilder(
                  order: 2,
                  text:
                      'Use IntroStepBuilder to wrap the widget you need to guide.'
                      ' Add the necessary order to it, and then add the key in the builder method to the widget.',
                  builder: (context, key) => Text(
                    'Tap the floatingActionButton to start.',
                    key: key,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                IntroStepBuilder(
                  order: 3,
                  text:
                      'If you need more configuration, please refer to Advanced Usage.',
                  builder: (context, key) => Text(
                    'And you can use `buttonTextBuilder` to set the button text.',
                    key: key,
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: IntroStepBuilder(
          order: 1,
          text: 'OK, let\'s start.',
          builder: (context, key) => FloatingActionButton(
            key: key,
            child: const Icon(
              Icons.play_arrow,
            ),
            onPressed: () {
              Intro.of(context).start();
            },
          ),
        ),
      ),
      onWillPop: () async {
        Intro intro = Intro.of(context);

        if (intro.status.isOpen == true) {
          intro.dispose();
          return false;
        }
        return true;
      },
    );
  }
}
