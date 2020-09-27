# flutter_intro

[![pub package](https://img.shields.io/pub/v/flutter_intro.svg)](https://pub.dartlang.org/packages/flutter_intro)

A better way for new feature introduction and step-by-step users guide for your Flutter project.

<img src='https://raw.githubusercontent.com/tal-tech/flutter_intro/master/doc/example1.gif' width='300' />

## Usage

To use this package, add `flutter_intro` as a [dependency in your pubspec.yaml file](https://flutter.dev/docs/development/packages-and-plugins/using-packages).

### 初始化

```dart
import 'package:flutter_intro/flutter_intro.dart';

Intro intro = Intro(
  /// 总共的引导页数量，必传
  stepCount: 4,

  /// 高亮区域与 widget 的内边距
  padding: EdgeInsets.all(8),

  /// 高亮区域的圆角半径
  borderRadius: BorderRadius.all(Radius.circular(4)),

  /// 使用库默认提供的 useDefaultTheme 可以快速构建引导页
  /// 需要自定义引导页样式和内容，需要自己实现 widgetBuilder 方法
  widgetBuilder: StepWidgetBuilder.useDefaultTheme(
    /// 提示文本
    texts: [
      '你好呀，我是 Flutter Intro。',
      '我可以帮你在 Flutter 项目中快读实现 Step By Step 引导。',
      '我的用法也十分简单，你可以通过 example 和 api 文档快速掌握和使用。',
      '为了快速实现引导，我也默认提供了一套样式，开箱即用，祝大家使用愉快，再见！',
    ],
    /// 按钮文字
    btnLabel: '我知道了',
    /// 是否在按钮后显示当前步骤
    showStepLabel: true,
  ),
);
```
<img src='https://raw.githubusercontent.com/tal-tech/flutter_intro/master/doc/img1.png' width='300' />

### 给需要加引导的 Widget 绑定 globalKey

第一步里面的 `intro` 对象中包含 `keys` 属性，`keys` 为一个长度为 `stepCount` 的 `globalKey` 数组，将数组中的 `globalKey` 绑定到对应组件上即可。

```dart
Placeholder(
  /// 第一个引导页即绑定 keys 中的第一项
  key: intro.keys[0]
)
```

### 启动

大功告成！

```dart
intro.start(context);
```

## 自定义 widgetBuilder 方法

如果你需要完全自定义引导页样式和内容，需要自己实现 `widgetBuilder` 方法。

```dart
final Widget Function(StepWidgetParams params) widgetBuilder;
```

该方法会在引导页出现时由 `flutter_intro` 内部调用，并会将当前页面上的一些数据通过参数的形式 `StepWidgetParams` 传进来，最终渲染在屏幕上的为此方法返回的组件。

```dart
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

  /// 高亮组件左上角坐标
  final Offset offset;
}
```

<img src='https://raw.githubusercontent.com/tal-tech/flutter_intro/master/doc/img2.png' width='300' />

`StepWidgetParams` 提供了生成引导页所需要的所有参数，默认提供的主题也是基于此参数生成引导页。

## Example

```dart
class _MyHomePageState extends State<MyHomePage> {
  Intro intro;

  _MyHomePageState() {
    /// init Intro
    intro = Intro(
      stepCount: 4,

      /// use defaultTheme, or you can implement widgetBuilder function yourself
      widgetBuilder: StepWidgetBuilder.useDefaultTheme(
        texts: [
          '你好呀，我是 Flutter Intro。',
          '我可以帮你在 Flutter 项目中快读实现 Step By Step 引导。',
          '我的用法也十分简单，你可以通过 example 和 api 文档快速掌握和使用。',
          '为了快速实现引导，我也默认提供了一套样式，开箱即用，祝大家使用愉快，再见！',
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(microseconds: 0), () {
      /// start the intro
      intro.start(context);
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SizedBox.expand(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 100,
                child: Placeholder(
                  /// 2nd guide
                  key: intro.keys[1],
                  fallbackHeight: 100,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Placeholder(
                /// 3rd guide
                key: intro.keys[2],
                fallbackHeight: 100,
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 100,
                    child: Placeholder(
                      /// 4th guide
                      key: intro.keys[3],
                      fallbackHeight: 300,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        /// 1st guide
        key: intro.keys[0],
        child: Icon(
          Icons.play_arrow,
        ),
        onPressed: () {
          intro.start(context);
        },
      ),
    );
  }
}
```

