import 'package:flutter/foundation.dart';

@immutable
class ConsoleLogLevelText {
  final String info;
  final String error;
  final String success;
  final String warning;

  const ConsoleLogLevelText(
      {required this.info,
      required this.error,
      required this.success,
      required this.warning});

  ConsoleLogLevelText copyWith({
    String? info,
    String? error,
    String? success,
    String? warning,
  }) {
    return ConsoleLogLevelText(
        info: info ?? this.info,
        error: error ?? this.error,
        success: success ?? this.success,
        warning: warning ?? this.warning);
  }
}
