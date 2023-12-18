import 'package:custom_logger/src/console_formatter.dart';
import 'package:custom_logger/src/models/custom_logger_exception.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:custom_logger/custom_logger.dart';

const isCustomLoggerException = TypeMatcher<CustomLoggerException>();

final logLevelStartChecks = (
  info: '${ConsoleFormatter.consoleColorCodes.cyan}| ',
  warning: '${ConsoleFormatter.consoleColorCodes.orange}| ',
  error: '${ConsoleFormatter.consoleColorCodes.red}| ',
  success: '${ConsoleFormatter.consoleColorCodes.green}| '
);

void main() {
  var consoleOutput = '';
  List<String> consoleOutputLines = [];

  setUp(() {
    CustomLogger.reset();
    CustomLogger.addListener((message) {
      consoleOutput = message.toString();
      consoleOutputLines = consoleOutput.split('\n');
    });
  });

  List<String> filterLines(String pattern) {
    return consoleOutputLines
        .where((element) => element.startsWith(pattern))
        .toList();
  }

  group('Test default outputs', () {
    test('Information log level', () {
      CustomLogger.info('Info test');
      expect(consoleOutput.contains('Information'), true);
      expect(consoleOutput.contains('Info test'), true);
      expect(consoleOutput.contains('|'), true);
      expect(consoleOutput.contains('='), true);
      expect(consoleOutput.contains(' 💬'), true);
      expect(consoleOutput.contains('test/custom_logger_test.dart'), true);
      expect(filterLines(logLevelStartChecks.info).length, 4);
      expect('='.allMatches(filterLines(logLevelStartChecks.info).last).length,
          128);
    });

    test('Warning log level', () {
      CustomLogger.warning('Warning test');
      expect(consoleOutput.contains('Warning'), true);
      expect(consoleOutput.contains('Warning test'), true);
      expect(consoleOutput.contains('|'), true);
      expect(consoleOutput.contains('='), true);
      expect(consoleOutput.contains('💢'), true);
      expect(consoleOutput.contains('test/custom_logger_test.dart'), true);
      expect(filterLines(logLevelStartChecks.warning).length, 4);
      expect(
          '='.allMatches(filterLines(logLevelStartChecks.warning).last).length,
          128);
    });

    test('Error log level', () {
      CustomLogger.error('Error test');
      expect(consoleOutput.contains('Error'), true);
      expect(consoleOutput.contains('Error test'), true);
      expect(consoleOutput.contains('|'), true);
      expect(consoleOutput.contains('='), true);
      expect(consoleOutput.contains('⛔'), true);
      expect(consoleOutput.contains('test/custom_logger_test.dart'), true);
      expect(filterLines(logLevelStartChecks.error).length, 4);
      expect('='.allMatches(filterLines(logLevelStartChecks.error).last).length,
          128);
    });

    test('Success log level', () {
      CustomLogger.success('Success test');
      expect(consoleOutput.contains('Success'), true);
      expect(consoleOutput.contains('Success test'), true);
      expect(consoleOutput.contains('|'), true);
      expect(consoleOutput.contains('='), true);
      expect(consoleOutput.contains('✅'), true);
      expect(consoleOutput.contains('test/custom_logger_test.dart'), true);
      expect(filterLines(logLevelStartChecks.success).length, 4);
      expect(
          '='.allMatches(filterLines(logLevelStartChecks.success).last).length,
          128);
    });
  });

  group('Test title change', () {
    test('Information log level', () {
      CustomLogger.setInfoTitle('New info title');
      CustomLogger.info('Info test');
      expect(consoleOutput.contains('New info title'), true);
      expect(consoleOutput.contains('Info test'), true);
      expect(consoleOutput.contains('|'), true);
      expect(consoleOutput.contains('='), true);
      expect(consoleOutput.contains(' 💬'), true);
      expect(consoleOutput.contains('test/custom_logger_test.dart'), true);
      expect(filterLines(logLevelStartChecks.info).length, 4);
      expect('='.allMatches(filterLines(logLevelStartChecks.info).last).length,
          128);
    });

    test('Warning log level', () {
      CustomLogger.setWarningTitle('New warning title');
      CustomLogger.warning('Warning test');
      expect(consoleOutput.contains('New warning title'), true);
      expect(consoleOutput.contains('Warning test'), true);
      expect(consoleOutput.contains('|'), true);
      expect(consoleOutput.contains('='), true);
      expect(consoleOutput.contains('💢'), true);
      expect(consoleOutput.contains('test/custom_logger_test.dart'), true);
      expect(filterLines(logLevelStartChecks.warning).length, 4);
      expect(
          '='.allMatches(filterLines(logLevelStartChecks.warning).last).length,
          128);
    });

    test('Error log level', () {
      CustomLogger.setErrorTitle('New error title');
      CustomLogger.error('Error test');
      expect(consoleOutput.contains('New error title'), true);
      expect(consoleOutput.contains('Error test'), true);
      expect(consoleOutput.contains('|'), true);
      expect(consoleOutput.contains('='), true);
      expect(consoleOutput.contains('⛔'), true);
      expect(consoleOutput.contains('test/custom_logger_test.dart'), true);
      expect(filterLines(logLevelStartChecks.error).length, 4);
      expect('='.allMatches(filterLines(logLevelStartChecks.error).last).length,
          128);
    });

    test('Success log level', () {
      CustomLogger.setSuccessTitle('New success title');
      CustomLogger.success('Success test');
      expect(consoleOutput.contains('New success title'), true);
      expect(consoleOutput.contains('Success test'), true);
      expect(consoleOutput.contains('|'), true);
      expect(consoleOutput.contains('='), true);
      expect(consoleOutput.contains('✅'), true);
      expect(consoleOutput.contains('test/custom_logger_test.dart'), true);
      expect(filterLines(logLevelStartChecks.success).length, 4);
      expect(
          '='.allMatches(filterLines(logLevelStartChecks.success).last).length,
          128);
    });

    test('Other log levels unaffected by title change', () {
      CustomLogger.setSuccessTitle('New success title');

      CustomLogger.error('Error test');
      expect(consoleOutput.contains('Error'), true);
      expect(consoleOutput.contains('Error test'), true);
      expect(consoleOutput.contains('|'), true);
      expect(consoleOutput.contains('='), true);
      expect(consoleOutput.contains('⛔'), true);
      expect(consoleOutput.contains('test/custom_logger_test.dart'), true);
      consoleOutputLines = consoleOutput.split('\n');
      expect(filterLines(logLevelStartChecks.error).length, 4);
      expect('='.allMatches(filterLines(logLevelStartChecks.error).last).length,
          128);

      CustomLogger.setErrorTitle('New error title');
      CustomLogger.error('Error test');
      expect(consoleOutput.contains('New error title'), true);
    });
  });

  group('Test package info change', () {
    test('Information log level', () {
      CustomLogger.info('Info test with caller info');
      expect(consoleOutput.contains('Information'), true);
      expect(consoleOutput.contains('Info test'), true);
      expect(consoleOutput.contains('|'), true);
      expect(consoleOutput.contains('='), true);
      expect(consoleOutput.contains(' 💬'), true);
      expect(consoleOutput.contains('test/custom_logger_test.dart'), true);
      expect(filterLines(logLevelStartChecks.info).length, 4);
      expect('='.allMatches(filterLines(logLevelStartChecks.info).last).length,
          128);

      CustomLogger.toggleCallerInfo(false);
      CustomLogger.info('Info test without caller info');
      expect(consoleOutput.contains('Information'), true);
      expect(consoleOutput.contains('Info test'), true);
      expect(consoleOutput.contains('|'), true);
      expect(consoleOutput.contains('='), true);
      expect(consoleOutput.contains(' 💬'), true);
      expect(consoleOutput.contains('test/custom_logger_test.dart'), false);
      expect(filterLines(logLevelStartChecks.info).length, 3);
      expect('='.allMatches(filterLines(logLevelStartChecks.info).last).length,
          128);
    });

    test('Warning log level', () {
      CustomLogger.warning('Warning test with caller info');
      expect(consoleOutput.contains('Warning'), true);
      expect(consoleOutput.contains('Warning test'), true);
      expect(consoleOutput.contains('|'), true);
      expect(consoleOutput.contains('='), true);
      expect(consoleOutput.contains('💢'), true);
      expect(consoleOutput.contains('test/custom_logger_test.dart'), true);
      expect(filterLines(logLevelStartChecks.warning).length, 4);
      expect(
          '='.allMatches(filterLines(logLevelStartChecks.warning).last).length,
          128);

      CustomLogger.toggleCallerInfo(false);
      CustomLogger.warning('Warning test without caller info');
      expect(consoleOutput.contains('Warning'), true);
      expect(consoleOutput.contains('Warning test'), true);
      expect(consoleOutput.contains('|'), true);
      expect(consoleOutput.contains('='), true);
      expect(consoleOutput.contains('💢'), true);
      expect(consoleOutput.contains('test/custom_logger_test.dart'), false);
      expect(filterLines(logLevelStartChecks.warning).length, 3);
      expect(
          '='.allMatches(filterLines(logLevelStartChecks.warning).last).length,
          128);
    });

    test('Error log level', () {
      CustomLogger.error('Error test with caller info');
      expect(consoleOutput.contains('Error'), true);
      expect(consoleOutput.contains('Error test'), true);
      expect(consoleOutput.contains('|'), true);
      expect(consoleOutput.contains('='), true);
      expect(consoleOutput.contains('⛔'), true);
      expect(consoleOutput.contains('test/custom_logger_test.dart'), true);
      expect(filterLines(logLevelStartChecks.error).length, 4);
      expect('='.allMatches(filterLines(logLevelStartChecks.error).last).length,
          128);

      CustomLogger.toggleCallerInfo(false);
      CustomLogger.error('Error test without caller info');

      expect(consoleOutput.contains('Error'), true);
      expect(consoleOutput.contains('Error test'), true);
      expect(consoleOutput.contains('|'), true);
      expect(consoleOutput.contains('='), true);
      expect(consoleOutput.contains('⛔'), true);
      expect(consoleOutput.contains('test/custom_logger_test.dart'), false);
      expect(filterLines(logLevelStartChecks.error).length, 3);
      expect('='.allMatches(filterLines(logLevelStartChecks.error).last).length,
          128);
    });

    test('Success log level', () {
      CustomLogger.success('Success test');
      expect(consoleOutput.contains('Success'), true);
      expect(consoleOutput.contains('Success test'), true);
      expect(consoleOutput.contains('|'), true);
      expect(consoleOutput.contains('='), true);
      expect(consoleOutput.contains('✅'), true);
      expect(consoleOutput.contains('test/custom_logger_test.dart'), true);
      expect(filterLines(logLevelStartChecks.success).length, 4);
      expect(
          '='.allMatches(filterLines(logLevelStartChecks.success).last).length,
          128);

      CustomLogger.toggleCallerInfo(false);
      CustomLogger.success('Success test');
      expect(consoleOutput.contains('Success'), true);
      expect(consoleOutput.contains('Success test'), true);
      expect(consoleOutput.contains('|'), true);
      expect(consoleOutput.contains('='), true);
      expect(consoleOutput.contains('✅'), true);
      expect(consoleOutput.contains('test/custom_logger_test.dart'), false);
      expect(filterLines(logLevelStartChecks.success).length, 3);
      expect('='.allMatches(filterLines(logLevelStartChecks.success).last).length, 128);
    });
  });

  test('Test exception on error', () {
    CustomLogger.reset();

    CustomLogger.toggleExceptionOnError(true);

    expect(() => CustomLogger.error('This should throw an exception'),
        throwsA(isCustomLoggerException));
  });

  test('Test line breaks', () {
    CustomLogger.setLineBreaksAfterLog(5);
    CustomLogger.info('Info test');
  });
}
