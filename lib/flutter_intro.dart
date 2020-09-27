library flutter_intro;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_intro/delay_rendered_widget.dart';
import 'package:flutter_intro/step_widget_params.dart';

export 'package:flutter_intro/step_widget_builder.dart';
export 'package:flutter_intro/step_widget_params.dart';

/// Flutter Intro 主类
///
/// 实例化 [Intro] 对象时传入 [stepCount]，和 [widgetBuilder]
/// 从 [Intro.keys] 获取 [GlobalKey]，加入到需要添加引导页的 [Widget] 上
/// 最后执行 [start] 方法，参数为当前的 [BuildContext]，即可
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
  double _widgetWidth;
  double _widgetHeight;
  Offset _widgetOffset;
  OverlayEntry _overlayEntry;
  int _currentStepIndex = 0;
  Widget _stepWidget;
  List<GlobalKey> _globalKeys = [];
  final Color _maskColor = Colors.black.withOpacity(.6);
  final Duration _animationDuration = Duration(milliseconds: 300);

  /// 引导页内容生成方法，该方法会在引导页出现时由 [Intro] 内部调用，
  /// 并会将当前页面上的一些参数通过 [StepWidgetParams] 传进来
  final Widget Function(StepWidgetParams params) widgetBuilder;

  /// [Widget] 选中区域的 [padding]，默认为 [EdgeInsets.all(8)]
  final EdgeInsets padding;

  /// [Widget] 选中区域的 [borderRadius]，默认为 [BorderRadius.all(Radius.circular(4))]
  final BorderRadiusGeometry borderRadius;

  /// 总共有多少步
  final int stepCount;

  /// 创建一个 Intro 实例，参数 [stepCount] 为引导页数量
  /// [widgetBuilder] 为引导页生成方法，返回一个 [Widget] 作为引导页
  Intro({
    @required this.widgetBuilder,
    @required this.stepCount,
    this.borderRadius = const BorderRadius.all(Radius.circular(4)),
    this.padding = const EdgeInsets.all(8),
  }) : assert(stepCount > 0) {
    for (int i = 0; i < stepCount; i++) {
      _globalKeys.add(GlobalKey());
    }
  }

  List<GlobalKey> get keys => _globalKeys;

  void _getWidgetInfo(GlobalKey globalKey) {
    RenderBox renderBox = globalKey.currentContext.findRenderObject();
    _widgetWidth = renderBox.size.width + padding.horizontal;
    _widgetHeight = renderBox.size.height + padding.vertical;
    _widgetOffset = Offset(
      renderBox.localToGlobal(Offset.zero).dx - padding.left,
      renderBox.localToGlobal(Offset.zero).dy - padding.top,
    );
  }

  Widget _maskBuilder({
    @required double width,
    @required double height,
    BlendMode backgroundBlendMode,
    @required double left,
    @required double top,
    Widget child,
  }) {
    return AnimatedPositioned(
      duration: _animationDuration,
      child: AnimatedContainer(
        padding: padding,
        decoration: BoxDecoration(
          color: Colors.white,
          backgroundBlendMode: backgroundBlendMode,
          borderRadius: borderRadius,
        ),
        width: width,
        height: height,
        duration: _animationDuration,
        child: child,
      ),
      left: left,
      top: top,
    );
  }

  void _showOverlay(
    BuildContext context,
    GlobalKey globalKey,
  ) {
    Size screenSize = MediaQuery.of(context).size;
    _overlayEntry = new OverlayEntry(
      builder: (BuildContext context) {
        return DelayRenderedWidget(
          removed: _removed,
          childPersist: true,
          duration: _animationDuration,
          child: Material(
            color: Colors.transparent,
            child: Stack(
              children: [
                ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    _maskColor,
                    BlendMode.srcOut,
                  ),
                  child: Stack(
                    children: [
                      _maskBuilder(
                        width: screenSize.width,
                        height: screenSize.height,
                        backgroundBlendMode: BlendMode.dstOut,
                        left: 0,
                        top: 0,
                      ),
                      _maskBuilder(
                        width: _widgetWidth,
                        height: _widgetHeight,
                        left: _widgetOffset.dx,
                        top: _widgetOffset.dy,
                      ),
                    ],
                  ),
                ),
                DelayRenderedWidget(
                  child: _stepWidget,
                ),
              ],
            ),
          ),
        );
      },
    );
    Overlay.of(context).insert(_overlayEntry);
  }

  void _onNext(BuildContext context) {
    _currentStepIndex++;
    if (_currentStepIndex < stepCount) {
      _createStepWidget(context);
      _overlayEntry.markNeedsBuild();
    }
  }

  void _onPrev(BuildContext context) {
    _currentStepIndex--;
    if (_currentStepIndex >= 0) {
      _createStepWidget(context);
      _overlayEntry.markNeedsBuild();
    }
  }

  void _createStepWidget(BuildContext context) {
    _getWidgetInfo(_globalKeys[_currentStepIndex]);
    Size screenSize = MediaQuery.of(context).size;
    Size widgetSize = Size(_widgetWidth, _widgetHeight);

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
      onFinish: () {
        _removed = true;
        _overlayEntry.markNeedsBuild();
        Timer(_animationDuration, () {
          _overlayEntry.remove();
        });
      },
    ));
  }

  /// 触发引导操作开始方法
  ///
  /// [context] 当前环境 [BuildContext]
  void start(BuildContext context) {
    _removed = false;
    _currentStepIndex = 0;
    _createStepWidget(context);
    _showOverlay(
      context,
      _globalKeys[_currentStepIndex],
    );
  }
}
