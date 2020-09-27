import 'package:flutter/material.dart';

/// 生成引导页时系统调用 [IntroStep.widgetBuilder] 时传入的数据
///
class StepWidgetParams {
  /// 返回前一个引导页方法，如果没有，则为 null
  final VoidCallback onPrev;

  /// 进入下一个引导页方法，如果没有，则为 null
  final VoidCallback onNext;

  /// 结束所有引导页方法
  final VoidCallback onFinish;

  /// 当前执行到第几个引导页，从 0 开始
  final int currentStepIndex;

  /// 引导页的总数
  final int stepCount;

  /// 屏幕的宽高
  final Size screenSize;

  /// 高亮组件的的宽高
  final Size size;

  /// 当前被添加引导页的 [Widget] 的左上角的坐标
  final Offset offset;

  StepWidgetParams({
    this.onPrev,
    this.onNext,
    this.onFinish,
    @required this.screenSize,
    @required this.size,
    @required this.currentStepIndex,
    @required this.stepCount,
    @required this.offset,
  });

  @override
  String toString() {
    return 'StepWidgetParams(currentStepIndex: $currentStepIndex, stepCount: $stepCount, size: $size, screenSize: $screenSize, offset: $offset)';
  }
}
