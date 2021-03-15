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

  /// Which guide page is currently displayed, starting from 0
  final int currentStepIndex;

  /// Total number of guide pages
  final int stepCount;

  /// The width and height of the screen
  final Size screenSize;

  /// The width and height of the highlighted component
  final Size size;

  /// The coordinates of the upper left corner of the highlighted component
  final Offset? offset;

  StepWidgetParams({
    this.onPrev,
    this.onNext,
    required this.onFinish,
    required this.screenSize,
    required this.size,
    required this.currentStepIndex,
    required this.stepCount,
    required this.offset,
  });

  @override
  String toString() {
    return 'StepWidgetParams(currentStepIndex: $currentStepIndex, stepCount: $stepCount, size: $size, screenSize: $screenSize, offset: $offset)';
  }
}
