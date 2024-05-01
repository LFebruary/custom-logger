import 'dart:ui';
import 'package:custom_logger/src/console_formatter.dart';
import 'package:custom_logger/src/models/console_log_level_text.dart';
import 'package:custom_logger/src/models/custom_logger_exception.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// A custom logger class for handling console output with color formatting.
class CustomLogger {
  /// Singleton instance of the CustomLogger class
  static CustomLogger _singleton = CustomLogger._privateConstructor();

  FlutterExceptionHandler? _originalOnError;
  ErrorCallback? _originalDispatcherError;
  FirebaseCrashlytics? _firebaseCrashlytics;

  static void logToFirebase(FirebaseCrashlytics crashlytics) async {
    _singleton._firebaseCrashlytics = crashlytics;
  }

  static void catchUnhandledExceptions(Function()? onError) {
    WidgetsFlutterBinding.ensureInitialized();

    _singleton._originalOnError = FlutterError.onError;
    _singleton._originalDispatcherError = PlatformDispatcher.instance.onError;

    FlutterError.onError = (FlutterErrorDetails errorDetails) async {
      error(errorDetails.exceptionAsString(), stackTrace: errorDetails.stack);
      onError?.call();
    };

    PlatformDispatcher.instance.onError = (errorThrown, stack) {
      error(errorThrown.toString(), stackTrace: stack);
      return true;
    };
  }

  CustomLogger._privateConstructor();

  List<void Function(Object? message)> listeners = [];

  static void addListener(void Function(Object? message) listener) {
    instance.listeners.add(listener);
  }

  static void reset() {
    _singleton.listeners = [];
    FlutterError.onError = _singleton._originalOnError;
    PlatformDispatcher.instance.onError = _singleton._originalDispatcherError;
    _singleton = CustomLogger._privateConstructor();
  }

  /// Retrieves the singleton instance of the CustomLogger class.
  static CustomLogger get instance => _singleton;

  /// The number of line breaks to display after each log.
  int lineBreaksAfterLog = 1;

  /// Determines whether to log caller information along with each message.
  bool logCallerInfo = true;

  /// A flag indicating whether the app should throw an exception when an error is logged.
  ///
  /// When set to true, the application will throw an exception if an error log is triggered.
  /// Defaults to false, allowing errors to be logged without causing exceptions.
  bool throwExceptionOnError = false;

  /// Toggles the behavior of throwing exceptions on error logging.
  ///
  /// [throwExceptionOnError] enables or disables the application from throwing exceptions
  /// when an error log is encountered.
  static void toggleExceptionOnError(bool throwExceptionOnError) {
    instance.throwExceptionOnError = throwExceptionOnError;
  }

  /// Prefixes and suffixes for different log levels.
  ConsoleLogLevelText logLevelPrefixSuffix =
      ConsoleFormatter.defaultLogLevelPrefixSuffix;

  /// Titles for different log levels.
  ConsoleLogLevelText logLevelTitle = ConsoleFormatter.defaultLogLevelTitle;

  /// Sets the number of line breaks to display after each log.
  ///
  /// [lineBreaksAfterLog] specifies the number of line breaks to appear in the console
  ///
  /// after each log. This allows controlling the visual separation between logged messages.
  static void setLineBreaksAfterLog(int lineBreaksAfterLog) {
    instance.lineBreaksAfterLog = lineBreaksAfterLog;
  }

  /// Toggles the logging of caller information.
  ///
  /// [logCallerInfo] determines whether to include caller information in the logged messages.
  ///
  /// Enabling this option includes details about the file, line, and column where the log was triggered.
  static void toggleCallerInfo(bool logCallerInfo) {
    instance.logCallerInfo = logCallerInfo;
  }

  /// Sets the prefix and suffix for informational log messages.
  ///
  /// [prefixAndSuffix] defines the added content before and after informational log messages.
  ///
  /// This allows customizing the appearance of these messages in the console output.
  static void setInfoPrefixAndSuffix(String prefixAndSuffix) {
    instance.logLevelPrefixSuffix =
        instance.logLevelPrefixSuffix.copyWith(info: prefixAndSuffix);
  }

  /// Sets the prefix and suffix for warning log messages.
  ///
  /// [prefixAndSuffix] defines additional content placed before and after
  /// warning log messages. Customizing this content allows alteration of
  /// the appearance of warning messages in the console output.
  static void setWarningPrefixAndSuffix(String prefixAndSuffix) {
    instance.logLevelPrefixSuffix =
        instance.logLevelPrefixSuffix.copyWith(warning: prefixAndSuffix);
  }

  /// Sets the prefix and suffix for error log messages.
  ///
  /// [prefixAndSuffix] specifies additional content placed before and after
  /// error log messages. This customization option enables modification of
  /// the appearance of error messages in the console output.
  static void setErrorPrefixAndSuffix(String prefixAndSuffix) {
    instance.logLevelPrefixSuffix =
        instance.logLevelPrefixSuffix.copyWith(error: prefixAndSuffix);
  }

  /// Sets the prefix and suffix for success log messages.
  ///
  /// [prefixAndSuffix] represents additional content placed before and after
  /// success log messages. Customizing this content aids in the alteration of
  /// the appearance of success messages in the console output.2
  static void setSuccessPrefixAndSuffix(String prefixAndSuffix) {
    instance.logLevelPrefixSuffix =
        instance.logLevelPrefixSuffix.copyWith(success: prefixAndSuffix);
  }

  /// Sets the title for informational log messages.
  ///
  /// [title] represents the title or header text attached to informational log messages.
  /// Customizing this title allows clear identification and differentiation of these logs
  /// in the console output.
  static void setInfoTitle(String title) {
    instance.logLevelTitle = instance.logLevelTitle.copyWith(info: title);
  }

  /// Sets the title for warning log messages.
  ///
  /// [title] defines the header text attached to warning log messages.
  /// Customizing this title enables clear identification and differentiation of warnings
  /// within the console output.
  static void setWarningTitle(String title) {
    instance.logLevelTitle = instance.logLevelTitle.copyWith(warning: title);
  }

  /// Sets the title for error log messages.
  ///
  /// [title] represents the header text attached to error log messages.
  /// Modifying this title aids in clear identification and differentiation of errors
  /// within the console output.
  static void setErrorTitle(String title) {
    instance.logLevelTitle = instance.logLevelTitle.copyWith(error: title);
  }

  /// Sets the title for success log messages.
  ///
  /// [title] defines the header text attached to success log messages.
  /// Customizing this title allows clear identification and differentiation of success messages
  /// within the console output.
  static void setSuccessTitle(String title) {
    instance.logLevelTitle = instance.logLevelTitle.copyWith(success: title);
  }

  /// Generates a formatted log string with color coding and optional details.
  ///
  /// [title] represents the main message content.
  ///
  /// [detail] holds additional details to be logged.
  ///
  /// [colorCode] is the ASCII code used for color formatting.
  ///
  /// [totalLength] determines the total length of the log message (default: 128).
  ///
  /// [fillCharacter] specifies the character used for filling empty spaces.
  ///
  /// [divider] separates sections within the log message (default: ' ').
  ///
  /// [prefixSuffix] represents optional content before and after the title.
  ///
  /// [customStackTrace] is the stack trace for identifying the log origin.
  ///
  /// [showCallerPathInfo] toggles displaying caller path information (default: true).
  ///
  /// Returns a formatted log string ready to be printed to the console.
  static String _generateFormattedLogString(
    String title,
    String detail,
    String colorCode, {
    int lineLength = 128,
    String? fillCharacter,
    String divider = ' ',
    String? prefixSuffix,
    StackTrace? customStackTrace,
    bool showCallerPathInfo = true,
  }) {
    final formattedString = StringBuffer();
    formattedString.writeln(ConsoleFormatter.generateLogTitle(
        title: title,
        colorCode: colorCode,
        prefixSuffix: prefixSuffix,
        fillCharacter: fillCharacter,
        divider: divider,
        lineLength: lineLength));

    String? callerInfo;

    if (showCallerPathInfo) {
      final caller =
          StackFrame.fromStackTrace(customStackTrace ?? StackTrace.current)[3];
      callerInfo =
          'package:${caller.package}/${caller.packagePath}:${caller.line}:${caller.column}';
    }

    formattedString.writeln(ConsoleFormatter.generateLogDetail(
        detail: detail, colorCode: colorCode, callerInfo: callerInfo));

    formattedString.writeln(ConsoleFormatter.generateLogEnd(
        fillCharacter: fillCharacter,
        lineLength: lineLength,
        colorCode: colorCode));

    return formattedString.toString();
  }

  /// Logs formatted messages with color and optional details.
  ///
  /// [title] represents the main message content
  ///
  /// [detail] holds additional details to be logged.
  ///
  /// [colorCode] is the ASCII code used for color formatting.
  ///
  /// [totalLength] determines the total length of the log message (default: 128).
  ///
  /// [fillCharacter] specifies the character used for filling empty spaces.
  ///
  /// [divider] separates sections within the log message (default: ' ').
  ///
  /// [prefixSuffix] represents optional content before and after the title.
  ///
  /// [customStackTrace] is the stack trace for identifying the log origin.
  ///
  /// [showCallerPathInfo] toggles displaying caller path information (default: true).
  ///
  /// This method logs messages with proper formatting, color, and optional details
  /// in debug mode, considering various customization options for log appearance.
  static void logFormattedMessage(
    String title,
    String detail,
    String colorCode, {
    int lineLength = 128,
    String? fillCharacter,
    String divider = ' ',
    String? prefixSuffix,
    StackTrace? customStackTrace,
    bool showCallerPathInfo = true,
  }) {
    // if (!kDebugMode) return;

    final formattedLog = _generateFormattedLogString(
      title,
      detail,
      colorCode,
      lineLength: lineLength,
      fillCharacter: fillCharacter,
      divider: divider,
      prefixSuffix: prefixSuffix,
      customStackTrace: customStackTrace,
      showCallerPathInfo: showCallerPathInfo,
    );

    if (instance.listeners.isNotEmpty) {
      for (final listener in instance.listeners) {
        listener(formattedLog);
      }
    }

    debugPrint(formattedLog);

    if (instance.lineBreaksAfterLog > 0) {
      debugPrint('\n' * instance.lineBreaksAfterLog);
    }
  }

  /// Logs an error message.
  ///
  /// [object] represents the error object or content to be logged.
  ///
  /// [showCallerPathInfo] toggles displaying caller path information (default: value from logger configuration).
  ///
  /// [stackTrace] is an optional stack trace used to identify the error's origin.
  ///
  /// This method formats and logs the provided error [object] with red color coding and necessary details.
  static void error(
    Object? object, {
    bool? showCallerPathInfo,
    StackTrace? stackTrace,
  }) {
    logFormattedMessage(
      instance.logLevelTitle.error,
      object.toString(),
      ConsoleFormatter.consoleColorCodes.red,
      prefixSuffix: instance.logLevelPrefixSuffix.error,
      showCallerPathInfo: showCallerPathInfo ?? instance.logCallerInfo,
    );

    if (instance.throwExceptionOnError) {
      throw CustomLoggerException(
          title: instance.logLevelTitle.error,
          detail: object.toString(),
          message: _generateFormattedLogString(
            instance.logLevelTitle.error,
            object.toString(),
            ConsoleFormatter.consoleColorCodes.red,
            prefixSuffix: instance.logLevelPrefixSuffix.error,
            showCallerPathInfo: showCallerPathInfo ?? instance.logCallerInfo,
          ));
    } else if (!kDebugMode && _singleton._firebaseCrashlytics != null) {
      FirebaseCrashlytics.instance.recordError(
        error,
        stackTrace,
        information: [
          _generateFormattedLogString(
            instance.logLevelTitle.error,
            object.toString(),
            ConsoleFormatter.consoleColorCodes.red,
            prefixSuffix: instance.logLevelPrefixSuffix.error,
            showCallerPathInfo: showCallerPathInfo ?? instance.logCallerInfo,
          )
        ],
      );
    }
  }

  /// Logs an informational message.
  ///
  /// [object] represents the information object or content to be logged.
  ///
  /// [showCallerPathInfo] toggles displaying caller path information (default: value from logger configuration).
  ///
  /// This method formats and logs the provided [object] with cyan color coding and necessary details as an informational message.
  static void info(
    Object? object, {
    bool? showCallerPathInfo,
  }) {
    logFormattedMessage(
      instance.logLevelTitle.info,
      object.toString(),
      ConsoleFormatter.consoleColorCodes.cyan,
      prefixSuffix: instance.logLevelPrefixSuffix.info,
      showCallerPathInfo: showCallerPathInfo ?? instance.logCallerInfo,
    );
  }

  /// Logs a success message.
  ///
  /// [object] represents the success object or content to be logged.
  ///
  /// [showCallerPathInfo] toggles displaying caller path information (default: value from logger configuration).
  ///
  /// This method formats and logs the provided [object] with green color coding and necessary details as a success message.
  static void success(
    Object? object, {
    bool? showCallerPathInfo,
  }) {
    logFormattedMessage(
      instance.logLevelTitle.success,
      object.toString(),
      ConsoleFormatter.consoleColorCodes.green,
      prefixSuffix: instance.logLevelPrefixSuffix.success,
      showCallerPathInfo: showCallerPathInfo ?? instance.logCallerInfo,
    );
  }

  /// Logs a warning message.
  ///
  /// [object] represents the warning object or content to be logged.
  ///
  /// [showCallerPathInfo] toggles displaying caller path information (default: value from logger configuration).
  ///
  /// This method formats and logs the provided [object] with orange color coding and necessary details as a warning message.
  static void warning(
    Object? object, {
    bool? showCallerPathInfo,
  }) {
    logFormattedMessage(
      instance.logLevelTitle.warning,
      object.toString(),
      ConsoleFormatter.consoleColorCodes.orange,
      prefixSuffix: instance.logLevelPrefixSuffix.warning,
      showCallerPathInfo: showCallerPathInfo ?? instance.logCallerInfo,
    );
  }

  static void wtf(
    Object? object, {
    bool? showCallerPathInfo,
  }) {
    logFormattedMessage(
      instance.logLevelTitle.wtf,
      object.toString(),
      ConsoleFormatter.consoleColorCodes.red,
      prefixSuffix: instance.logLevelPrefixSuffix.wtf,
      showCallerPathInfo: showCallerPathInfo ?? instance.logCallerInfo,
    );

    final message = _generateFormattedLogString(
      instance.logLevelTitle.wtf,
      object.toString(),
      ConsoleFormatter.consoleColorCodes.red,
      prefixSuffix: instance.logLevelPrefixSuffix.wtf,
      showCallerPathInfo: showCallerPathInfo ?? instance.logCallerInfo,
    );

    FirebaseCrashlytics.instance.recordError(
      error,
      null,
      information: [
        _generateFormattedLogString(
          instance.logLevelTitle.error,
          object.toString(),
          ConsoleFormatter.consoleColorCodes.red,
          prefixSuffix: instance.logLevelPrefixSuffix.error,
          showCallerPathInfo: showCallerPathInfo ?? instance.logCallerInfo,
        )
      ],
      fatal: true,
    );

    throw CustomLoggerException(
        title: instance.logLevelTitle.wtf,
        detail: object.toString(),
        message: message);
  }
}
