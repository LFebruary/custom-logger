import 'package:custom_logger/src/models/console_log_level_text.dart';
import 'package:intl/intl.dart';

/// Utility class providing methods and constants for console formatting.
class ConsoleFormatter {
    /// Default padding character used for formatting console output.
  static const defaultPaddingCharacter = '|';

  /// Default fill character used for formatting console output.
  static const defaultFillCharacter = '=';

  /// Default timestamp format used for log messages.
  static final defaultTimestampFormat = DateFormat('HH:mm:ss:SSS');

  /// Reset color code to revert console color formatting to default.
  static const resetColorCode = '\x1B[0m';

  /// Color codes for console output formatting.
  ///
  /// Contains predefined escape sequences for various colors in the console.
  static const consoleColorCodes = (
    green: '\x1B[32m',
    red: '\x1B[31m',
    cyan: '\x1B[36m',
    white: '\x1B[37m',
    orange: '\x1B[33m',
  );

  /// Default prefix and suffix for different log levels.
  ///
  /// Contains default symbols or emojis for different log levels like info, error, success, and warning.
  static const defaultLogLevelPrefixSuffix = ConsoleLogLevelText(
    info: '💬',
    error: '⛔',
    success: '✅',
    warning: '💢'
  );

  /// Default color codes for different log levels.
  ///
  /// Provides default color codes corresponding to different log levels like info, error, success, and warning.
  static final defaultLogLevelColorCodes = ConsoleLogLevelText(
    info: consoleColorCodes.cyan,
    error: consoleColorCodes.red,
    success: consoleColorCodes.green,
    warning: consoleColorCodes.orange
  );

  /// Default titles for different log levels.
  ///
  /// Provides default titles or header texts for different log levels like info, error, success, and warning.
  static const defaultLogLevelTitle = ConsoleLogLevelText(
    info: 'Information',
    error: 'Error',
    success: 'Success',
    warning: 'Warning'
  );

  /// Pads the provided [content] with the specified character to signify a line in the console.
  ///
  /// [content] is the text to be padded and formatted as a line in the console.
  /// [paddingCharacter] specifies the character used for padding; defaults to '|'.
  /// This method prepares content to be displayed as a line in the console output.
  static String padLine(
    String content, {
    String paddingCharacter = defaultPaddingCharacter,
  }) =>
      '$paddingCharacter $content';

  /// Applies color to the provided [text] using the specified [asciiColorCode].
  ///
  /// [text] is the content to be colored.
  /// [asciiColorCode] is the ASCII code representing the desired color.
  /// This method applies color formatting to the provided text.
  static String colorize(String text, String asciiColorCode) =>
      '$asciiColorCode$text$resetColorCode';


  // Fills the text with the specified [fillCharacter] repeated for [repetitions] times.
  ///
  /// [repetitions] specify the number of times the [fillCharacter] will be repeated.
  /// [fillCharacter] specifies the character used for filling; defaults to '='.
  /// This method fills text by repeating the fill character to achieve a desired length.
  static String fillText(int repetitions, {String? fillCharacter}) => (fillCharacter ?? defaultFillCharacter) * repetitions;
}