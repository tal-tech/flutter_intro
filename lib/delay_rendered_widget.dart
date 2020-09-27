import 'dart:async';

import 'package:flutter/material.dart';

/// 延迟渲染类，用来实现 [Intro] 的动画效果，
/// 为内部使用类，开发者无需关心
///
class DelayRenderedWidget extends StatefulWidget {
  /// 需要渐显渐隐的子元素
  final Widget child;

  /// [child] 是否持续渲染，即动画只会有一次
  final bool childPersist;

  /// 动画持续时间
  final Duration duration;

  /// [child] 是否需要移除（隐藏）
  final bool removed;

  const DelayRenderedWidget({
    Key key,
    this.removed = false,
    this.duration = const Duration(milliseconds: 200),
    this.child,
    this.childPersist = false,
  }) : super(key: key);
  @override
  _DelayRenderedWidgetState createState() => _DelayRenderedWidgetState();
}

class _DelayRenderedWidgetState extends State<DelayRenderedWidget> {
  double opacity = 0;
  Widget child;
  Timer timer;

  /// 动画之间的时间间隔
  final Duration durationSpace = Duration(milliseconds: 100);
  @override
  void initState() {
    super.initState();
    child = widget.child;
    timer = Timer(durationSpace, () {
      if (mounted) {
        setState(() {
          opacity = 1;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  void didUpdateWidget(DelayRenderedWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    var duration = widget.duration;
    if (widget.removed) {
      setState(() {
        opacity = 0;
      });
      return;
    }
    if (!identical(oldWidget.child, widget.child)) {
      if (widget.childPersist) {
        setState(() {
          child = widget.child;
        });
      } else {
        setState(() {
          opacity = 0;
        });
        Timer(
          Duration(
            milliseconds:
                duration.inMilliseconds + durationSpace.inMilliseconds,
          ),
          () {
            setState(() {
              child = widget.child;
              opacity = 1;
            });
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: opacity,
      duration: widget.duration,
      child: child,
    );
  }
}
