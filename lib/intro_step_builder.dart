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

  final String? simpleText;

  IntroStepBuilder({
    Key? key,
    required this.order,
    required this.builder,
    this.simpleText,
    this.overlayBuilder,
  })  : assert(simpleText != null || overlayBuilder != null),
        super(key: key);

  @override
  State<IntroStepBuilder> createState() => _IntroStepBuilderState();
}

class _IntroStepBuilderState extends State<IntroStepBuilder> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    FlutterIntro? flutterIntro = FlutterIntro.of(context);

    if (flutterIntro != null &&
        flutterIntro._keys.indexWhere((e) => e.key == widget._key) == -1) {
      flutterIntro._keys.add(IntroKey(
        key: widget._key,
        order: widget.order,
        simpleText: widget.simpleText,
      ));
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
