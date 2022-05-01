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
class _StepWidgetBuilder {
  static OverlayPosition getOverlayPosition({
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
    OverlayPosition position = OverlayPosition(
      width: 0,
      crossAxisAlignment: CrossAxisAlignment.start,
    );

    if (topArea > bottomArea) {
      position.bottom = bottomArea + height + 16;
    } else {
      position.top = offset.dy + height + 12;
    }

    if (leftArea > rightArea) {
      position.right = rightArea <= 0 ? 16.0 : rightArea;
      position.crossAxisAlignment = CrossAxisAlignment.end;
      position.width = min(leftArea + width - 16, screenWidth * 0.618);
    } else {
      position.left = offset.dx <= 0 ? 16.0 : offset.dx;
      position.width = min(rightArea + width - 16, screenWidth * 0.618);
    }

    /// The distance on the right side is very large, it is more beautiful on the right side
    if (rightArea > 0.8 * topArea && rightArea > 0.8 * bottomArea) {
      position.left = offset.dx + width + 16;
      position.top = offset.dy - 4;
      position.bottom = null;
      position.right = null;
      position.width = min<double>(position.width, rightArea * 0.8);
    }

    /// The distance on the left is large, it is more beautiful on the left side
    if (leftArea > 0.8 * topArea && leftArea > 0.8 * bottomArea) {
      position.right = rightArea + width + 16;
      position.top = offset.dy - 4;
      position.bottom = null;
      position.left = null;
      position.crossAxisAlignment = CrossAxisAlignment.end;
      position.width = min<double>(position.width, leftArea * 0.8);
    }

    return position;
  }
}
