part of flutter_intro;

class FlutterIntroException implements Exception {
  final dynamic message;

  FlutterIntroException([this.message]);

  String toString() {
    Object? message = this.message;
    if (message == null) return "FlutterIntroException";
    return "FlutterIntroException: $message";
  }
}
