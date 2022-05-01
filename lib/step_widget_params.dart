part of flutter_intro;

/// The data passed in when the system calls [IntroStep.widgetBuilder] when the guide page is generated
///
class StepWidgetParams {
  /// Return to the previous guide page method, or null if there is none
  final VoidCallback? onPrev;

  /// Enter the next guide page method, or null if there is none
  final VoidCallback? onNext;

  /// End all guide page methods
  final VoidCallback onFinish;

  /// The width and height of the screen
  final Size screenSize;

  /// The width and height of the highlighted component
  final Size size;

  /// The coordinates of the upper left corner of the highlighted component
  final Offset? offset;

  /// The step order
  final int order;

  StepWidgetParams({
    this.onPrev,
    this.onNext,
    required this.order,
    required this.onFinish,
    required this.screenSize,
    required this.size,
    required this.offset,
  });

  @override
  String toString() {
    return 'StepWidgetParams(order: $order, size: $size, screenSize: $screenSize, offset: $offset)';
  }
}
