library flutter_intro;

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

part 'delay_rendered_widget.dart';
part 'intro_status.dart';
part 'step_widget_builder.dart';
part 'step_widget_params.dart';
part 'throttling.dart';

/// Flutter Intro main class
///
/// Pass in [stepCount] when instantiating [Intro] object, and [widgetBuilder]
/// Obtain [GlobalKey] from [Intro.keys] and add it to the [Widget] where you need to add a guide page
/// Finally execute the [start] method, the parameter is the current [BuildContext], you can
///
/// {@tool snippet}
/// ```dart
/// final Intro intro = Intro(
///   stepCount: 4,
///   widgetBuilder: widgetBuilder,
/// );
///
/// Container(
///   key: intro.keys[0],
/// );
/// Text(
///   'need focus widget',
///   key: intro.keys[1],
/// );
///
/// intro.start(context);
/// ```
/// {@end-tool}
///
class Intro {
  bool _removed = false;
  double? _widgetWidth;
  double? _widgetHeight;
  Offset? _widgetOffset;
  OverlayEntry? _overlayEntry;
  int _currentStepIndex = 0;
  Widget? _stepWidget;
  List<Map> _configMap = [];
  List<GlobalKey> _globalKeys = [];
  late Duration _animationDuration;
  late Size _lastScreenSize;
  final _th = _Throttling(duration: Duration(milliseconds: 500));

  /// The mask color of step page
  final Color maskColor;

  /// Current step page index
  /// 2021-03-31 @caden
  /// I don’t remember why this parameter was exposed at the time,
  /// it seems to be useless, and there is a bug in this one, so let’s block it temporarily.
  // int get currentStepIndex => _currentStepIndex;

  /// No animation
  final bool noAnimation;

  // Click on whether the mask is allowed to be closed.
  final bool maskClosable;

  /// The method of generating the content of the guide page,
  /// which will be called internally by [Intro] when the guide page appears.
  /// And will pass in some parameters on the current page through [StepWidgetParams]
  final Widget Function(StepWidgetParams params) widgetBuilder;

  /// [Widget] [padding] of the selected area, the default is [EdgeInsets.all(8)]
  final EdgeInsets padding;

  /// [Widget] [borderRadius] of the selected area, the default is [BorderRadius.all(Radius.circular(4))]
  final BorderRadiusGeometry borderRadius;

  /// How many steps are there in total
  final int stepCount;

  /// The highlight widget tapped callback
  final void Function(IntroStatus introStatus)? onHighlightWidgetOnTap;

  /// Create an Intro instance, the parameter [stepCount] is the number of guide pages
  /// [widgetBuilder] is the method of generating the guide page, and returns a [Widget] as the guide page
  Intro({
    required this.widgetBuilder,
    required this.stepCount,
    this.maskColor = const Color.fromRGBO(0, 0, 0, .6),
    this.noAnimation = false,
    this.maskClosable = false,
    this.borderRadius = const BorderRadius.all(Radius.circular(4)),
    this.padding = const EdgeInsets.all(8),
    this.onHighlightWidgetOnTap,
  }) : assert(stepCount > 0) {
    _animationDuration =
        noAnimation ? Duration(milliseconds: 0) : Duration(milliseconds: 300);
    for (int i = 0; i < stepCount; i++) {
      _globalKeys.add(GlobalKey());
      _configMap.add({});
    }
  }

  List<GlobalKey> get keys => _globalKeys;

  /// Set the configuration of the specified number of steps
  ///
  /// [stepIndex] Which step of configuration needs to be modified
  /// [padding] Padding setting
  /// [borderRadius] BorderRadius setting
  void setStepConfig(
    int stepIndex, {
    EdgeInsets? padding,
    BorderRadiusGeometry? borderRadius,
  }) {
    assert(stepIndex >= 0 && stepIndex < stepCount);
    _configMap[stepIndex] = {
      'padding': padding,
      'borderRadius': borderRadius,
    };
  }

  /// Set the configuration of multiple steps
  ///
  /// [stepsIndex] Which steps of configuration needs to be modified
  /// [padding] Padding setting
  /// [borderRadius] BorderRadius setting
  void setStepsConfig(
    List<int> stepsIndex, {
    EdgeInsets? padding,
    BorderRadiusGeometry? borderRadius,
  }) {
    assert(stepsIndex
        .every((stepIndex) => stepIndex >= 0 && stepIndex < stepCount));
    stepsIndex.forEach((index) {
      setStepConfig(
        index,
        padding: padding,
        borderRadius: borderRadius,
      );
    });
  }

  void _getWidgetInfo(GlobalKey globalKey) {
    EdgeInsets? currentConfig = _configMap[_currentStepIndex]['padding'];
    RenderBox renderBox =
        globalKey.currentContext!.findRenderObject() as RenderBox;
    _widgetWidth = renderBox.size.width +
        (currentConfig?.horizontal ?? padding.horizontal);
    _widgetHeight =
        renderBox.size.height + (currentConfig?.vertical ?? padding.vertical);
    _widgetOffset = Offset(
      renderBox.localToGlobal(Offset.zero).dx -
          (currentConfig?.left ?? padding.left),
      renderBox.localToGlobal(Offset.zero).dy -
          (currentConfig?.top ?? padding.top),
    );
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

  void _showOverlay(
    BuildContext context,
    GlobalKey globalKey,
  ) {
    _overlayEntry = new OverlayEntry(
      builder: (BuildContext context) {
        Size screenSize = MediaQuery.of(context).size;

        if (screenSize.width != _lastScreenSize.width ||
            screenSize.height != _lastScreenSize.height) {
          _lastScreenSize = screenSize;
          _th.throttle(() {
            _createStepWidget(context);
            _overlayEntry!.markNeedsBuild();
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
                                if (stepCount - 1 == _currentStepIndex) {
                                  _onFinish();
                                } else {
                                  _onNext(context);
                                }
                              }
                            : null,
                      ),
                      _widgetBuilder(
                        width: _widgetWidth,
                        height: _widgetHeight,
                        left: _widgetOffset!.dx,
                        top: _widgetOffset!.dy,
                        // Skipping through the intro very fast may cause currentStepIndex to out of bounds
                        // I have tried to fix it, here is just to make the code safer
                        // https://github.com/tal-tech/flutter_intro/issues/22
                        borderRadiusGeometry: _currentStepIndex < stepCount
                            ? _configMap[_currentStepIndex]['borderRadius'] ??
                                borderRadius
                            : borderRadius,
                        onTap: onHighlightWidgetOnTap != null
                            ? () {
                                IntroStatus introStatus = getStatus();
                                onHighlightWidgetOnTap!(introStatus);
                              }
                            : null,
                      ),
                    ],
                  ),
                ),
                _DelayRenderedWidget(
                  duration: _animationDuration,
                  child: _stepWidget,
                ),
              ],
            ),
          ),
        );
      },
    );
    Overlay.of(context)!.insert(_overlayEntry!);
  }

  void _onNext(BuildContext context) {
    if (_currentStepIndex + 1 < stepCount) {
      _currentStepIndex++;
      _renderStep(context);
    }
  }

  void _onPrev(BuildContext context) {
    if (_currentStepIndex - 1 >= 0) {
      _currentStepIndex--;
      _renderStep(context);
    }
  }

  void _onFinish() {
    if (_overlayEntry == null) return;
    _removed = true;
    _overlayEntry!.markNeedsBuild();
    Timer(_animationDuration, () {
      if (_overlayEntry == null) return;
      _overlayEntry!.remove();
      _overlayEntry = null;
    });
  }

  void _createStepWidget(BuildContext context) {
    _getWidgetInfo(_globalKeys[_currentStepIndex]);
    Size screenSize = MediaQuery.of(context).size;
    Size widgetSize = Size(_widgetWidth!, _widgetHeight!);

    _stepWidget = widgetBuilder(StepWidgetParams(
      screenSize: screenSize,
      size: widgetSize,
      onNext: _currentStepIndex == stepCount - 1
          ? null
          : () {
              _onNext(context);
            },
      onPrev: _currentStepIndex == 0
          ? null
          : () {
              _onPrev(context);
            },
      offset: _widgetOffset,
      currentStepIndex: _currentStepIndex,
      stepCount: stepCount,
      onFinish: _onFinish,
    ));
  }

  void _renderStep(BuildContext context) {
    _createStepWidget(context);
    _overlayEntry!.markNeedsBuild();
  }

  /// Trigger the start method of the guided operation
  ///
  /// [context] Current environment [BuildContext]
  void start(BuildContext context) {
    _lastScreenSize = MediaQuery.of(context).size;
    _removed = false;
    _currentStepIndex = 0;
    _createStepWidget(context);
    _showOverlay(
      context,
      _globalKeys[_currentStepIndex],
    );
  }

  /// Destroy the guide page and release all resources
  void dispose() {
    _onFinish();
  }

  /// Get intro instance current status
  IntroStatus getStatus() {
    bool isOpen = _overlayEntry != null;
    IntroStatus introStatus = IntroStatus(
      isOpen: isOpen,
      currentStepIndex: _currentStepIndex,
    );
    return introStatus;
  }
}
