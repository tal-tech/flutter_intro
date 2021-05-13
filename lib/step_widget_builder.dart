part of flutter_intro;

/// The [WidgetBuilder] class that comes with Flutter Intro
///
/// You can use the defaultTheme provided by Flutter Intro
///
/// {@tool snippet}
/// ```dart
/// final Intro intro = Intro(
///   stepCount: 2,
///   widgetBuilder: StepWidgetBuilder.useDefaultTheme([
///     'say something',
///     'say other something',
///   ]),
/// );
/// ```
/// {@end-tool}
///
class StepWidgetBuilder {
  @visibleForTesting
  static Map smartGetPosition({
    required Size size,
    required Size screenSize,
    required Offset offset,
  }) =>
      _smartGetPosition(size: size, screenSize: screenSize, offset: offset);

  static Map _smartGetPosition({
    required Size size,
    required Size screenSize,
    required Offset offset,
  }) {
    double height = size.height;
    double width = size.width;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    double bottomArea = screenHeight - offset.dy - height;
    double topArea = screenHeight - height - bottomArea;
    double rightArea = screenWidth - offset.dx - width;
    double leftArea = screenWidth - width - rightArea;
    Map position = Map();
    position['crossAxisAlignment'] = CrossAxisAlignment.start;

    if (topArea > bottomArea) {
      position['bottom'] = bottomArea + height + 16;
    } else {
      position['top'] = offset.dy + height + 12;
    }

    if (leftArea > rightArea) {
      position['right'] = rightArea <= 0 ? 16.0 : rightArea;
      position['crossAxisAlignment'] = CrossAxisAlignment.end;
      position['width'] = min(leftArea + width - 16, screenWidth * 0.618);
    } else {
      position['left'] = offset.dx <= 0 ? 16.0 : offset.dx;
      position['width'] = min(rightArea + width - 16, screenWidth * 0.618);
    }

    /// The distance on the right side is very large, it is more beautiful on the right side
    if (rightArea > 0.8 * topArea && rightArea > 0.8 * bottomArea) {
      position['left'] = offset.dx + width + 16;
      position['top'] = offset.dy - 4;
      position['bottom'] = null;
      position['right'] = null;
      position['width'] = min<double>(position['width'], rightArea * 0.8);
    }

    /// The distance on the left is large, it is more beautiful on the left side
    if (leftArea > 0.8 * topArea && leftArea > 0.8 * bottomArea) {
      position['right'] = rightArea + width + 16;
      position['top'] = offset.dy - 4;
      position['bottom'] = null;
      position['left'] = null;
      position['crossAxisAlignment'] = CrossAxisAlignment.end;
      position['width'] = min<double>(position['width'], leftArea * 0.8);
    }

    return position;
  }

  /// Use default theme.
  ///
  /// * [texts] is an array of text on the guide page.
  /// * [buttonTextBuilder] is the method of generating button text.
  /// * [maskClosable] has remove to intro class, deprecated and not working now, use like below.
  /// {@tool snippet}
  /// ```dart
  /// final Intro intro = Intro(
  ///   maskClosable: true,
  /// );
  /// ```
  /// {@end-tool}
  /// the parameters are the current page index and the total number of pages in sequence.
  static Widget Function(StepWidgetParams params) useDefaultTheme({
    required List<String> texts,
    required String Function(int currentStepIndex, int stepCount)
        buttonTextBuilder,
    @deprecated bool? maskClosable,
  }) {
    return (StepWidgetParams stepWidgetParams) {
      int currentStepIndex = stepWidgetParams.currentStepIndex;
      int stepCount = stepWidgetParams.stepCount;
      Offset offset = stepWidgetParams.offset!;

      Map position = _smartGetPosition(
        screenSize: stepWidgetParams.screenSize,
        size: stepWidgetParams.size,
        offset: offset,
      );

      return Stack(
        children: [
          Positioned(
            child: Container(
              width: position['width'],
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: position['crossAxisAlignment'],
                children: [
                  Text(
                    currentStepIndex > texts.length - 1
                        ? ''
                        : texts[currentStepIndex],
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      height: 1.4,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  SizedBox(
                    height: 28,
                    child: OutlinedButton(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(
                          Colors.white,
                        ),
                        overlayColor: MaterialStateProperty.all<Color>(
                          Colors.white.withOpacity(0.1),
                        ),
                        side: MaterialStateProperty.all<BorderSide>(
                          BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: 8,
                          ),
                        ),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                          StadiumBorder(),
                        ),
                      ),
                      onPressed: () {
                        if (stepCount - 1 == currentStepIndex) {
                          stepWidgetParams.onFinish();
                        } else {
                          stepWidgetParams.onNext!();
                        }
                      },
                      child: Text(
                        buttonTextBuilder(currentStepIndex, stepCount),
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            left: position['left'],
            top: position['top'],
            bottom: position['bottom'],
            right: position['right'],
          ),
        ],
      );
    };
  }

  /// Use advanced theme.
  ///
  /// * [widgetBuilder] the widget returned by this method will be displayed on the screen.
  /// it's worth noting that the maximum display width of the widget will be limited by the current screen width.
  static Widget Function(StepWidgetParams params) useAdvancedTheme({
    required Widget Function(StepWidgetParams params) widgetBuilder,
  }) {
    return (StepWidgetParams stepWidgetParams) {
      Offset offset = stepWidgetParams.offset!;

      Map position = _smartGetPosition(
        screenSize: stepWidgetParams.screenSize,
        size: stepWidgetParams.size,
        offset: offset,
      );

      return Stack(
        children: [
          Positioned(
            child: SizedBox(
              width: position['width'],
              child: widgetBuilder(stepWidgetParams),
            ),
            left: position['left'],
            top: position['top'],
            bottom: position['bottom'],
            right: position['right'],
          ),
        ],
      );
    };
  }
}
