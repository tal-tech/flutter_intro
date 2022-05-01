library flutter_intro;

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

part 'delay_rendered_widget.dart';
part 'flutter_intro_exception.dart';
part 'intro_button.dart';
part 'intro_status.dart';
part 'intro_step_builder.dart';
part 'overlay_position.dart';
part 'step_widget_builder.dart';
part 'step_widget_params.dart';
part 'throttling.dart';

class Intro extends InheritedWidget {
  static BuildContext? _context;
  static OverlayEntry? _overlayEntry;
  static bool _removed = false;
  static Size _screenSize = Size(0, 0);
  static Widget _overlayWidget = SizedBox.shrink();
  static IntroStepBuilder? _currentIntroStepBuilder;
  static Size _widgetSize = Size(0, 0);
  static Offset _widgetOffset = Offset(0, 0);

  final _th = _Throttling(duration: Duration(milliseconds: 500));
  final List<IntroStepBuilder> _introStepBuilderList = [];
  final List<IntroStepBuilder> _finishedIntroStepBuilderList = [];
  late final Duration _animationDuration;

  /// [Widget] [padding] of the selected area, the default is [EdgeInsets.all(8)]
  final EdgeInsets padding;

  /// [Widget] [borderRadius] of the selected area, the default is [BorderRadius.all(Radius.circular(4))]
  final BorderRadiusGeometry borderRadius;

  /// The mask color of step page
  final Color maskColor;

  /// No animation
  final bool noAnimation;

  /// Click on whether the mask is allowed to be closed.
  final bool maskClosable;

  /// [order] order
  final String Function(
    int order,
  )? buttonTextBuilder;

  Intro({
    this.padding = const EdgeInsets.all(8),
    this.borderRadius = const BorderRadius.all(Radius.circular(4)),
    this.maskColor = const Color.fromRGBO(0, 0, 0, .6),
    this.noAnimation = false,
    this.maskClosable = false,
    this.buttonTextBuilder,
    required Widget child,
  }) : super(child: child) {
    _animationDuration =
        noAnimation ? Duration(milliseconds: 0) : Duration(milliseconds: 300);
  }

  IntroStatus get status => IntroStatus(isOpen: _overlayEntry != null);

  bool get hasNextStep =>
      _currentIntroStepBuilder == null ||
      _introStepBuilderList.where(
            (element) {
              return element.order > _currentIntroStepBuilder!.order;
            },
          ).length >
          0;

  bool get hasPrevStep =>
      _finishedIntroStepBuilderList
          .indexWhere((element) => element == _currentIntroStepBuilder) >
      0;

  IntroStepBuilder? _getNextIntroStepBuilder({
    bool isUpdate = false,
  }) {
    if (isUpdate) {
      return _currentIntroStepBuilder;
    }
    int index = _finishedIntroStepBuilderList
        .indexWhere((element) => element == _currentIntroStepBuilder);
    if (index != _finishedIntroStepBuilderList.length - 1) {
      return _finishedIntroStepBuilderList[index + 1];
    } else {
      _introStepBuilderList.sort((a, b) => a.order - b.order);
      final introStepBuilder =
          _introStepBuilderList.cast<IntroStepBuilder?>().firstWhere(
                (e) => !_finishedIntroStepBuilderList.contains(e),
                orElse: () => null,
              );
      return introStepBuilder;
    }
  }

  IntroStepBuilder? _getPrevIntroStepBuilder({
    bool isUpdate = false,
  }) {
    if (isUpdate) {
      return _currentIntroStepBuilder;
    }
    int index = _finishedIntroStepBuilderList
        .indexWhere((element) => element == _currentIntroStepBuilder);
    if (index > 0) {
      return _finishedIntroStepBuilderList[index - 1];
    }
    return null;
  }

  Widget _widgetBuilder({
    double? width,
    double? height,
    BlendMode? backgroundBlendMode,
    required double left,
    required double top,
    double? bottom,
    double? right,
    BorderRadiusGeometry? borderRadiusGeometry,
    Widget? child,
    VoidCallback? onTap,
  }) {
    final decoration = BoxDecoration(
      color: Colors.white,
      backgroundBlendMode: backgroundBlendMode,
      borderRadius: borderRadiusGeometry,
    );
    return AnimatedPositioned(
      duration: _animationDuration,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          padding: padding,
          decoration: decoration,
          width: width,
          height: height,
          child: child,
          duration: _animationDuration,
        ),
      ),
      left: left,
      top: top,
      bottom: bottom,
      right: right,
    );
  }

  void _onFinish() {
    if (_overlayEntry == null) return;

    _removed = true;
    _overlayEntry!.markNeedsBuild();
    Timer(_animationDuration, () {
      if (_overlayEntry == null) return;
      _overlayEntry!.remove();
      _removed = false;
      _overlayEntry = null;
      _introStepBuilderList.clear();
      _finishedIntroStepBuilderList.clear();
    });
  }

  void _render({
    bool isUpdate = false,
    bool reverse = false,
  }) {
    IntroStepBuilder? introStepBuilder = reverse
        ? _getPrevIntroStepBuilder(
            isUpdate: isUpdate,
          )
        : _getNextIntroStepBuilder(
            isUpdate: isUpdate,
          );
    _currentIntroStepBuilder = introStepBuilder;

    if (introStepBuilder == null) {
      _onFinish();
      return;
    }

    if (introStepBuilder._key.currentContext == null) {
      throw FlutterIntroException(
        'The current context is null, because there is no widget in the tree that matches this global key.'
        ' Please check whether the key in IntroStepBuilder(order: ${introStepBuilder.order}) has forgotten to bind.'
        ' If you are already bound, it means you have encountered a bug, please let me know.',
      );
    }

    RenderBox renderBox =
        introStepBuilder._key.currentContext!.findRenderObject() as RenderBox;

    _screenSize = MediaQuery.of(_context!).size;
    _widgetSize = Size(
      renderBox.size.width +
          (introStepBuilder.padding?.horizontal ?? padding.horizontal),
      renderBox.size.height +
          (introStepBuilder.padding?.vertical ?? padding.vertical),
    );
    _widgetOffset = Offset(
      renderBox.localToGlobal(Offset.zero).dx -
          (introStepBuilder.padding?.left ?? padding.left),
      renderBox.localToGlobal(Offset.zero).dy -
          (introStepBuilder.padding?.top ?? padding.top),
    );

    OverlayPosition position = _StepWidgetBuilder.getOverlayPosition(
      screenSize: _screenSize,
      size: _widgetSize,
      offset: _widgetOffset,
    );

    if (!_finishedIntroStepBuilderList.contains(introStepBuilder)) {
      _finishedIntroStepBuilderList.add(introStepBuilder);
    }

    if (introStepBuilder.overlayBuilder != null) {
      _overlayWidget = Stack(
        children: [
          Positioned(
            child: SizedBox(
              child: introStepBuilder.overlayBuilder!(
                StepWidgetParams(
                  order: introStepBuilder.order,
                  onNext: hasNextStep ? _render : null,
                  onPrev: hasPrevStep
                      ? () {
                          _render(reverse: true);
                        }
                      : null,
                  onFinish: _onFinish,
                  screenSize: _screenSize,
                  size: _widgetSize,
                  offset: _widgetOffset,
                ),
              ),
            ),
            width: position.width,
            left: position.left,
            top: position.top,
            bottom: position.bottom,
            right: position.right,
          ),
        ],
      );
    } else if (introStepBuilder.text != null) {
      _overlayWidget = Stack(
        children: [
          Positioned(
            child: SizedBox(
              width: position.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: position.crossAxisAlignment,
                children: [
                  Text(
                    introStepBuilder.text!,
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
                  IntroButton(
                    text: buttonTextBuilder == null
                        ? 'Next'
                        : buttonTextBuilder!(introStepBuilder.order),
                    onPressed: _render,
                  ),
                ],
              ),
            ),
            left: position.left,
            top: position.top,
            bottom: position.bottom,
            right: position.right,
          ),
        ],
      );
    }

    if (_overlayEntry == null) {
      _createOverlay();
    } else {
      _overlayEntry!.markNeedsBuild();
    }
  }

  void _createOverlay() {
    _overlayEntry = new OverlayEntry(
      builder: (BuildContext context) {
        Size currentScreenSize = MediaQuery.of(context).size;

        if (_screenSize.width != currentScreenSize.width ||
            _screenSize.height != currentScreenSize.height) {
          _screenSize = currentScreenSize;

          _th.throttle(() {
            _render(
              isUpdate: true,
            );
          });
        }

        return _DelayRenderedWidget(
          removed: _removed,
          childPersist: true,
          duration: _animationDuration,
          child: Material(
            color: Colors.transparent,
            child: Stack(
              children: [
                ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    maskColor,
                    BlendMode.srcOut,
                  ),
                  child: Stack(
                    children: [
                      _widgetBuilder(
                        backgroundBlendMode: BlendMode.dstOut,
                        left: 0,
                        top: 0,
                        right: 0,
                        bottom: 0,
                        onTap: maskClosable
                            ? () {
                                Future.delayed(
                                  const Duration(milliseconds: 200),
                                  () {
                                    _render();
                                  },
                                );
                              }
                            : null,
                      ),
                      _widgetBuilder(
                        width: _widgetSize.width,
                        height: _widgetSize.height,
                        left: _widgetOffset.dx,
                        top: _widgetOffset.dy,
                        borderRadiusGeometry:
                            _currentIntroStepBuilder?.borderRadius ??
                                borderRadius,
                        onTap: _currentIntroStepBuilder?.onHighlightWidgetTap,
                      ),
                    ],
                  ),
                ),
                _DelayRenderedWidget(
                  duration: _animationDuration,
                  child: _overlayWidget,
                ),
              ],
            ),
          ),
        );
      },
    );
    Overlay.of(_context!)!.insert(_overlayEntry!);
  }

  void start() {
    dispose();
    _render();
  }

  void refresh() {
    _render(
      isUpdate: true,
    );
  }

  static Intro? of(BuildContext context) {
    _context = context;
    return context.dependOnInheritedWidgetOfExactType<Intro>();
  }

  void dispose() {
    _onFinish();
  }

  @override
  bool updateShouldNotify(Intro oldWidget) {
    return false;
  }
}
