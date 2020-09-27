import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_intro/step_widget_params.dart';

/// Flutter Intro 自带的 [WidgetBuilder] 类
///
/// 可以使用 Flutter Intro 提供的 defaultTheme
///
/// {@tool snippet}
/// ```dart
/// final Intro intro = Intro(
///   stepCount: 2,
///   widgetBuilder: StepWidgetBuilder.useDefaultTheme([
///     'say something',
///     'say other something',
///   ]),
/// );
/// ```
/// {@end-tool}
///
class StepWidgetBuilder {
  static Map _smartGetPosition({
    Size size,
    Size screenSize,
    Offset offset,
  }) {
    double height = size.height;
    double width = size.width;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    double bottomArea = screenHeight - offset.dy - height;
    double topArea = screenHeight - height - bottomArea;
    double rightArea = screenWidth - offset.dx - width;
    double leftArea = screenWidth - width - rightArea;
    Map position = Map();
    position['crossAxisAlignment'] = CrossAxisAlignment.start;
    if (topArea > bottomArea) {
      position['bottom'] = bottomArea + height + 16;
    } else {
      position['top'] = offset.dy + height + 12;
    }
    if (leftArea > rightArea) {
      position['right'] = rightArea;
      position['crossAxisAlignment'] = CrossAxisAlignment.end;
    } else {
      position['left'] = offset.dx;
    }
    position['width'] = screenWidth * 0.618;

    /// 右侧距离很大，放在右侧视觉上更美观
    if (rightArea > 0.8 * topArea && rightArea > 0.8 * bottomArea) {
      position['left'] = offset.dx + width + 16;
      position['top'] = offset.dy - 4;
      position['bottom'] = null;
      position['right'] = null;
      position['width'] = min<double>(position['width'], rightArea * 0.8);
    }

    /// 左侧距离很大，放在左侧视觉上更美观
    if (leftArea > 0.8 * topArea && leftArea > 0.8 * bottomArea) {
      position['right'] = rightArea + width + 16;
      position['top'] = offset.dy - 4;
      position['bottom'] = null;
      position['left'] = null;
      position['crossAxisAlignment'] = CrossAxisAlignment.end;
      position['width'] = min<double>(position['width'], leftArea * 0.8);
    }
    return position;
  }

  /// 使用默认主题
  /// [texts] 文字提示列表，每一项为对应的引导页需要显示的文字
  /// [btnLabel] 下一步按钮中的文字，默认值为"我知道了"
  /// [showStepLabel] 是否在按钮后面显示步数指示器，默认显示
  static Widget Function(StepWidgetParams params) useDefaultTheme({
    @required List<String> texts,
    String btnLabel = '我知道了',
    bool showStepLabel = true,
  }) {
    return (StepWidgetParams stepWidgetParams) {
      int currentStepIndex = stepWidgetParams.currentStepIndex;
      int stepCount = stepWidgetParams.stepCount;
      Offset offset = stepWidgetParams.offset;

      Map position = _smartGetPosition(
        screenSize: stepWidgetParams.screenSize,
        size: stepWidgetParams.size,
        offset: offset,
      );

      return Stack(
        children: [
          Positioned(
            child: Container(
              width: position['width'],
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: position['crossAxisAlignment'],
                children: [
                  Text(
                    currentStepIndex > texts.length - 1
                        ? ''
                        : texts[currentStepIndex],
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
                  SizedBox(
                    height: 28,
                    child: OutlineButton(
                      padding: EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(64),
                        ),
                      ),
                      highlightedBorderColor: Colors.white,
                      borderSide: BorderSide(color: Colors.white),
                      textColor: Colors.white,
                      onPressed: stepCount - 1 == currentStepIndex
                          ? stepWidgetParams.onFinish
                          : stepWidgetParams.onNext,
                      child: Text(
                        '$btnLabel' +
                            (showStepLabel
                                ? '${currentStepIndex + 1}/$stepCount'
                                : ''),
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            left: position['left'],
            top: position['top'],
            bottom: position['bottom'],
            right: position['right'],
          ),
        ],
      );
    };
  }
}
