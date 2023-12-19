import 'package:custom_logger/src/console_formatter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

void main() {
  group('Test default formatting', () {
    test('Pad line with ${ConsoleFormatter.defaultPaddingCharacter}', () {
      final paddedText = ConsoleFormatter.padLine('Hello');
      expect(paddedText, '${ConsoleFormatter.defaultPaddingCharacter} Hello');
    });

    test(
        'Fill text with 5 "${ConsoleFormatter.defaultFillCharacter}" characters.',
        () {
      final filledText = ConsoleFormatter.fillText(5);
      expect(filledText.length, 5);
      expect(filledText, '=====');
    });

    group('Title generator', () {
      test('Basic log title', () {
        final timestamp = DateTime.now();
        final formattedTimestamp = DateFormat('HH:mm:ss:SSS').format(timestamp);
        final output = ConsoleFormatter.generateLogTitle(title: 'Test', timestamp: timestamp);
        expect(output, '| ====================================================== Test ======================================================$formattedTimestamp');
      });

      test('Basic log title with custom fill character', () {
        final timestamp = DateTime.now();
        final formattedTimestamp = DateFormat('HH:mm:ss:SSS').format(timestamp);
        final output = ConsoleFormatter.generateLogTitle(title: 'Test', timestamp: timestamp, fillCharacter: '*');
        expect(output, '| ****************************************************** Test ******************************************************$formattedTimestamp');
      });

      test('Basic log title with custom fill text', () {
        final timestamp = DateTime.now();
        final formattedTimestamp = DateFormat('HH:mm:ss:SSS').format(timestamp);
        final output = ConsoleFormatter.generateLogTitle(title: 'Test', timestamp: timestamp, fillCharacter: 'abcdefghi');
        expect(output, '| abcdefghiabcdefghiabcdefghiabcdefghiabcdefghiabcdefghi Test abcdefghiabcdefghiabcdefghiabcdefghiabcdefghiabcdefghi$formattedTimestamp');
      });

      test('Basic log title with orange color', () {
        final timestamp = DateTime.now();
        final formattedTimestamp = DateFormat('HH:mm:ss:SSS').format(timestamp);
        final output = ConsoleFormatter.generateLogTitle(title: 'Test', timestamp: timestamp, colorCode: ConsoleFormatter.consoleColorCodes.orange);
        expect(output, '\x1B[33m| ====================================================== Test ======================================================$formattedTimestamp\x1B[0m');
      });

      test('Default to now timestamp', () {
        final timestamp = DateTime.now();
        // We set this to ignore ms due to inaccuracy from invocation
        final formattedTimestamp = DateFormat('HH:mm:ss').format(timestamp);
        final output = ConsoleFormatter.generateLogTitle(title: 'Test', colorCode: ConsoleFormatter.consoleColorCodes.orange);
        expect(output.contains(formattedTimestamp), true);
      });
    });
  });

  test('Test default color codes', () {
    expect(ConsoleFormatter.consoleColorCodes.cyan, ConsoleFormatter.defaultLogLevelColorCodes.info);
    expect(ConsoleFormatter.consoleColorCodes.red, ConsoleFormatter.defaultLogLevelColorCodes.error);
    expect(ConsoleFormatter.consoleColorCodes.green, ConsoleFormatter.defaultLogLevelColorCodes.success);
    expect(ConsoleFormatter.consoleColorCodes.orange, ConsoleFormatter.defaultLogLevelColorCodes.warning);
  });

  group('Test custom formatting', () {
    test('Pad line with -', () {
      final paddedText =
          ConsoleFormatter.padLine('Hello', paddingCharacter: '-');
      expect(paddedText, '- Hello');
    });

    test('Apply red color to text and automatically end with reset', () {
      final coloredText = ConsoleFormatter.colorize(
          'Error', ConsoleFormatter.consoleColorCodes.red);
      expect(coloredText.contains('Error'), true);
      expect(coloredText.startsWith('\x1B[31m'), true);
      expect(coloredText.endsWith('\x1B[0m'), true);
    });

    test('Fill text with 5 asterisks', () {
      final filledText = ConsoleFormatter.fillText(5, fillCharacter: '*');
      expect(filledText.length, 5);
      expect(filledText, '*****');
    });
  });
}
