import 'package:custom_logger/src/console_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:custom_logger/custom_logger.dart';

void main() {
  test('Default log levels', () {
    var consoleOutput = '';
    CustomLogger.addListener((message) {
      consoleOutput = message.toString();
    });

    CustomLogger.info('Info test');
    expect(consoleOutput.contains('Information'), true);
    expect(consoleOutput.contains('Info test'), true);
    expect(consoleOutput.contains('|'), true);
    expect(consoleOutput.contains('='), true);
    expect(consoleOutput.contains(' 💬'), true);
    expect(consoleOutput.contains('test/custom_logger_test.dart'), true);
    var consoleOutputLines = consoleOutput.split('\n');
    var startCheck = '${ConsoleFormatter.consoleColorCodes.cyan}| ';
    expect(consoleOutputLines.where((element) => element.startsWith(startCheck)).length, 4);
    expect('='.allMatches(consoleOutputLines[3]).length, 128);

    CustomLogger.warning('Warning test');
    expect(consoleOutput.contains('Warning'), true);
    expect(consoleOutput.contains('Warning test'), true);
    expect(consoleOutput.contains('|'), true);
    expect(consoleOutput.contains('='), true);
    expect(consoleOutput.contains('💢'), true);
    expect(consoleOutput.contains('test/custom_logger_test.dart'), true);
    consoleOutputLines = consoleOutput.split('\n');
    startCheck = '${ConsoleFormatter.consoleColorCodes.orange}| ';
    expect(consoleOutputLines.where((element) => element.startsWith(startCheck)).length, 4);
    expect('='.allMatches(consoleOutputLines[3]).length, 128);

    CustomLogger.error('Error test');
    expect(consoleOutput.contains('Error'), true);
    expect(consoleOutput.contains('Error test'), true);
    expect(consoleOutput.contains('|'), true);
    expect(consoleOutput.contains('='), true);
    expect(consoleOutput.contains('⛔'), true);
    expect(consoleOutput.contains('test/custom_logger_test.dart'), true);
    consoleOutputLines = consoleOutput.split('\n');
    startCheck = '${ConsoleFormatter.consoleColorCodes.red}| ';
    expect(consoleOutputLines.where((element) => element.startsWith(startCheck)).length, 4);
    expect('='.allMatches(consoleOutputLines[3]).length, 128);

    CustomLogger.success('Success test');
    expect(consoleOutput.contains('Success'), true);
    expect(consoleOutput.contains('Success test'), true);
    expect(consoleOutput.contains('|'), true);
    expect(consoleOutput.contains('='), true);
    expect(consoleOutput.contains('✅'), true);
    expect(consoleOutput.contains('test/custom_logger_test.dart'), true);
    consoleOutputLines = consoleOutput.split('\n');
    startCheck = '${ConsoleFormatter.consoleColorCodes.green}| ';
    expect(consoleOutputLines.where((element) => element.startsWith(startCheck)).length, 4);
    expect('='.allMatches(consoleOutputLines[3]).length, 128);

  });

  test('Test instance title changes', () {
    CustomLogger.setInfoTitle('New info title');
    CustomLogger.info('Info test');

    CustomLogger.setWarningTitle('New warning title');
    CustomLogger.warning('Warning test');

    CustomLogger.setErrorTitle('New error title');
    CustomLogger.error('Error test');

    CustomLogger.setSuccessTitle('New success title');
    CustomLogger.success('Success test');
  });

  test('Test package info change', () {
    CustomLogger.info('Info test');
    CustomLogger.toggleCallerInfo(false);
    CustomLogger.info('Info test');
  });

  test('Test line breaks', () {
    CustomLogger.setLineBreaksAfterLog(5);
    CustomLogger.info('Info test');
  });
}
