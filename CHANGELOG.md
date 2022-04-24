## [3.0.0-dev.1]

* Prerelease, No documentation yet.

## [2.3.1]

* Throw a friendly error when something goes wrong.

## [2.3.0]

* Add `useAdvancedTheme` in `StepWidgetBuilder`, you can customize the component style at will. 

## [2.2.1]

* Rename `onHighlightWidgetOnTap` to `onHighlightWidgetTap`.

## [2.2.0]

* Breaking update: move `maskClosable` to `Intro`.
* Add `onHighlightWidgetOnTap` in `Intro`.
* Add `currentStepIndex` in `IntroStatus`.
* Fix the bug that when `maskClosable` is true, clicking on the highlighted widget will also trigger the event,
  Now only click on the blank area of the mask will trigger the event.

## [2.1.1]

* Fix bug.

## [2.1.0]

* Add `getStatus` method to get current status, it's very useful in some cases.
* Remove the `currentStepIndex` property exposed by the intro instance, it's useless and has bugs.

## [2.0.2]

* Fix bug.

## [2.0.1]

* Fix bug.

## [2.0.0]

* Migrating to null safety.
* Replace deprecated components.

## [1.1.0]

* Add `maskClosable` property in `defaultTheme` to set click on whether the mask is allowed to be closed.

## [1.0.0]

* Breaking update: remove `btnLabel` and `showStepLabel`.
* Add `maskColor` to set mask color of step page.

## [0.8.0]

* Add `noAnimation` property to disable animation.

## [0.7.0]

* Refactor the `useDefaultTheme` method, deprecated `btnLabel` and `showStepLabel`, and use `buttonTextBuilder` instead.

## [0.6.0]

* Expose `currentStepIndex` on intro instance.
* Fix bug.


## [0.5.1]

* Fix bug.

## [0.5.0]

* Add `dispose` method to destroy the guide page.

## [0.4.1]

* Fix style issues that may occur in some cases.

## [0.4.0]

* Fix the problem that the prompt text will exceed the screen boundary.
* Added `setStepConfig` and `setStepsConfig` methods to set step settings.

## [0.3.4]

* Improve Readme & API.

## [0.3.3]

* Improve Readme.

## [0.3.2]

* Migration code repositories address.

## [0.3.1]

* Fix readme.

## [0.3.0]

* Homepage change.

## [0.2.0]

* Breaking update: `StepWidgetParams` refactor.
* Improved documentation.

## [0.1.0]

* Breaking update: The calling method has been changed, and now uses a more concise way.

## [0.0.4]

* Added padding property.

## [0.0.3]

* Optimize animation effects.

## [0.0.2]

* Add Readme.

## [0.0.1]

* First version.
