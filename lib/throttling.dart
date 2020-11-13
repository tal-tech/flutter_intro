part of flutter_intro;

///  Throttling
///  Have method [throttle]
class _Throttling {
  Duration _duration;
  bool _isReady = true;
  Future<void> get _waiter => Future.delayed(_duration);
  Timer _timer;

  _Throttling({Duration duration = const Duration(seconds: 1)})
      : assert(duration is Duration && !duration.isNegative) {
    _duration = duration;
  }

  void throttle(Function func) {
    if (_timer != null) {
      _timer.cancel();
    }
    _timer = Timer(_duration, () {
      Function.apply(func, []);
    });
    if (!_isReady) {
      return null;
    }
    _isReady = false;
    _waiter.then((_) {
      _isReady = true;
    });
    _timer.cancel();
    Timer(Duration(seconds: 0), () {
      Function.apply(func, []);
    });
    return null;
  }
}
