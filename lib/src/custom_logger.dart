import 'package:custom_logger/src/console_formatter.dart';
import 'package:custom_logger/src/models/console_log_level_text.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

/// A custom logger class for handling console output with color formatting.
class CustomLogger {
  List<void Function(Object? message)> listeners = [];

  static void addListener(void Function(Object? message) listener) {
    instance.listeners.add(listener);
  }

  /// Singleton instance of the CustomLogger class
  static final CustomLogger _singleton = CustomLogger();

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
  static String generateFormattedLogString(
    String title,
    String detail,
    String colorCode, {
    int totalLength = 128,
    String? fillCharacter,
    String divider = ' ',
    String? prefixSuffix,
    StackTrace? customStackTrace,
    bool showCallerPathInfo = true,
  }) {
    final timestamp = DateFormat('HH:mm:ss:SSS').format(DateTime.now());
    final titleLength = title.length;

    int fillerLength = totalLength -
        titleLength -
        timestamp.length;

    if (divider.isNotEmpty) {
      fillerLength -= divider.length *
          ((prefixSuffix?.isNotEmpty ?? false)
              ? 3 * (prefixSuffix!.length) + (divider.length * 2)
              : (divider.length * 2));
    }
    fillerLength = fillerLength.isEven ? fillerLength : fillerLength + 1;

    final fill = ConsoleFormatter.fillText(fillerLength ~/ 2,
        fillCharacter: fillCharacter);


    final paddedTitle = prefixSuffix != null && prefixSuffix.isNotEmpty
        ? ConsoleFormatter.padLine(
            '$fill$divider$prefixSuffix$divider$title$divider$prefixSuffix$divider$fill')
        : ConsoleFormatter.padLine('$fill$divider$title$divider$fill');

    final formattedString = StringBuffer();
    formattedString
        .writeln(ConsoleFormatter.colorize(paddedTitle + timestamp, colorCode));
    formattedString.writeln(
        ConsoleFormatter.colorize(ConsoleFormatter.padLine(detail), colorCode));

    if (showCallerPathInfo) {
      final caller =
          StackFrame.fromStackTrace(customStackTrace ?? StackTrace.current)[3];
      final clickablePath =
          'package:${caller.package}/${caller.packagePath}:${caller.line}:${caller.column}';
      formattedString.writeln(ConsoleFormatter.colorize(
          ConsoleFormatter.padLine(clickablePath), colorCode));
    }

    formattedString.writeln(ConsoleFormatter.colorize(
        ConsoleFormatter.padLine(ConsoleFormatter.fillText(totalLength,
            fillCharacter: fillCharacter)),
        colorCode));

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
    int totalLength = 128,
    String? fillCharacter,
    String divider = ' ',
    String? prefixSuffix,
    StackTrace? customStackTrace,
    bool showCallerPathInfo = true,
  }) {
    // if (!kDebugMode) return;

    final formattedLog = generateFormattedLogString(
      title,
      detail,
      colorCode,
      totalLength: totalLength,
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

    print(formattedLog);

    if (instance.lineBreaksAfterLog > 0) {
      print('\n' * instance.lineBreaksAfterLog);
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
      throw Exception(generateFormattedLogString(
        instance.logLevelTitle.error,
        object.toString(),
        ConsoleFormatter.consoleColorCodes.red,
        prefixSuffix: instance.logLevelPrefixSuffix.error,
        showCallerPathInfo: showCallerPathInfo ?? instance.logCallerInfo,
      ));
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
}
