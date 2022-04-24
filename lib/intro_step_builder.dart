part of flutter_intro;

class IntroStepBuilder extends StatefulWidget {
  final Widget Function(
    BuildContext context,
    GlobalKey key,
  ) builder;

  final GlobalKey _key = GlobalKey();

  ///Set the running order, the smaller the number, the first
  final int order;

  /// The method of generating the content of the guide page,
  /// which will be called internally by [Intro] when the guide page appears.
  /// And will pass in some parameters on the current page through [StepWidgetParams]
  final Widget Function(StepWidgetParams params)? overlayBuilder;

  /// When highlight widget is tapped
  final VoidCallback? onHighlightWidgetTap;

  /// [Widget] [borderRadius] of the selected area, the default is [BorderRadius.all(Radius.circular(4))]
  final BorderRadiusGeometry? borderRadius;

  /// [Widget] [padding] of the selected area, the default is [EdgeInsets.all(8)]
  final EdgeInsets? padding;

  final String? text;

  IntroStepBuilder({
    Key? key,
    required this.order,
    required this.builder,
    this.text,
    this.overlayBuilder,
    this.borderRadius,
    this.onHighlightWidgetTap,
    this.padding,
  })  : assert(text != null || overlayBuilder != null),
        super(key: key);

  @override
  State<IntroStepBuilder> createState() => _IntroStepBuilderState();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'IntroStepBuilder(order: $order)';
  }
}

class _IntroStepBuilderState extends State<IntroStepBuilder> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Intro? flutterIntro = Intro.of(context);

    if (flutterIntro != null &&
        !flutterIntro._introStepBuilderList.contains(widget)) {
      flutterIntro._introStepBuilderList.add(widget);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      context,
      widget._key,
    );
  }
}
