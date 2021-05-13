import 'package:flutter/cupertino.dart';
import 'package:flutter_intro/flutter_intro.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'intro info position test1',
    () {
      Map map = StepWidgetBuilder.smartGetPosition(
        size: Size(
          10,
          10,
        ),
        screenSize: Size(
          100,
          100,
        ),
        offset: Offset(
          0,
          0,
        ),
      );
      expect(
        map,
        {
          'crossAxisAlignment': CrossAxisAlignment.start,
          'top': -4.0,
          'left': 26.0,
          'width': 61.8,
          'bottom': null,
          'right': null,
        },
      );
    },
  );

  test(
    'intro info position test2',
    () {
      Map map = StepWidgetBuilder.smartGetPosition(
        size: Size(
          10,
          10,
        ),
        screenSize: Size(
          100,
          100,
        ),
        offset: Offset(
          90,
          90,
        ),
      );
      expect(
        map,
        {
          'crossAxisAlignment': CrossAxisAlignment.end,
          'top': 86.0,
          'left': null,
          'width': 61.8,
          'bottom': null,
          'right': 26.0,
        },
      );
    },
  );
}
