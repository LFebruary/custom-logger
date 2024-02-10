import 'package:flutter/foundation.dart';

@immutable
class ConsoleLogLevelText {
  final String info;
  final String error;
  final String success;
  final String warning;
  final String wtf;

  const ConsoleLogLevelText(
      {required this.info,
      required this.error,
      required this.success,
      required this.warning, required this.wtf,});

  ConsoleLogLevelText copyWith({
    String? info,
    String? error,
    String? success,
    String? warning,
    String? wtf,
  }) {
    return ConsoleLogLevelText(
        info: info ?? this.info,
        error: error ?? this.error,
        success: success ?? this.success,
        warning: warning ?? this.warning,
        wtf: wtf ?? this.wtf,);
  }
}
