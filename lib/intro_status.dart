part of flutter_intro;

/// Intro current status
///
class IntroStatus {
  /// Flutter_intro is showing on the screen or not
  final bool isOpen;

  IntroStatus({
    required this.isOpen,
  });

  @override
  String toString() {
    return 'IntroStatus(isOpen: $isOpen)';
  }
}
