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
  static Map _smartGetPosition({
    Size size,
    Size screenSize,
    Offset offset,
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
  /// * [buttonTextBuilder] is the method of generating button text,
  /// the parameters are the current page index and the total number of pages in sequence.
  /// If it is provided, btnLabel and showStepLabel will be ignored.
  /// * [btnLabel] is the text in the next button, deprecated, use [buttonTextBuilder] to replace it.
  /// * [showStepLabel] indicates whether to display the current step number behind the button text, deprecated, please use [buttonTextBuilder] to replace it.
  static Widget Function(StepWidgetParams params) useDefaultTheme({
    @required List<String> texts,
    String Function(int currentStepIndex, int stepCount) buttonTextBuilder,
    @deprecated String btnLabel = 'I KNOW',
    @deprecated bool showStepLabel = true,
  }) {
    return (StepWidgetParams stepWidgetParams) {
      int currentStepIndex = stepWidgetParams.currentStepIndex;
      int stepCount = stepWidgetParams.stepCount;
      Offset offset = stepWidgetParams.offset;

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
                    child: OutlineButton(
                      padding: EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(64),
                        ),
                      ),
                      highlightedBorderColor: Colors.white,
                      borderSide: BorderSide(color: Colors.white),
                      textColor: Colors.white,
                      onPressed: stepCount - 1 == currentStepIndex
                          ? stepWidgetParams.onFinish
                          : stepWidgetParams.onNext,
                      child: Text(
                        (buttonTextBuilder != null
                                ? buttonTextBuilder(currentStepIndex, stepCount)
                                : '$btnLabel') +
                            ((showStepLabel && buttonTextBuilder == null)
                                ? ' ${currentStepIndex + 1}/$stepCount'
                                : ''),
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
}
