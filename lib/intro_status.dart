part of flutter_intro;

/// Intro current status
///
class IntroStatus {
  /// Flutter_intro is showing on the screen or not
  final bool isOpen;

  /// Current step page index
  final int currentStepIndex;

  IntroStatus({
    required this.isOpen,
    required this.currentStepIndex,
  });

  @override
  String toString() {
    return 'IntroStatus(isOpen: $isOpen, currentStepIndex: $currentStepIndex)';
  }
}
