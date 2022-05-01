part of flutter_intro;

class OverlayPosition {
  double? left;
  double? right;
  double? bottom;
  double? top;
  double width;
  CrossAxisAlignment crossAxisAlignment;

  OverlayPosition({
    this.left,
    this.right,
    this.bottom,
    this.top,
    required this.width,
    required this.crossAxisAlignment,
  });
}
