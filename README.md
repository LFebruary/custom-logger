# Custom Logger Library

The Custom Logger Library provides flexible logging functionalities for Dart applications, enabling customized console output with enhanced formatting and color-coded messages.

## Features

- **Color Formatting**: Customize log messages with various colors for improved readability.
- **Log Level Configuration**: Set different log levels and prefixes for information, errors, warnings, and successes.
- **Customizable Output**: Define total line lengths, characters for filling, dividers, and more for tailored log formatting.

## Installation

Add the following line to your `pubspec.yaml`:

```yaml
dependencies:
  custom_logger: ^1.0.0  # Replace with the latest version
```

Then, run:

```bash
$ flutter pub get
```

## Usage

Import the library:

```dart
import 'package:custom_logger/custom_logger.dart';
```

Initialize the logger:

```dart
final logger = CustomLogger.instance;
```

Customize logging options:

```dart
CustomLogger.setInfoPrefixAndSuffix('ℹ️');
CustomLogger.setErrorPrefixAndSuffix('❌');
```

Use the logger:

```dart
CustomLogger.info('This is an information message');
CustomLogger.error('This is an error message');
CustomLogger.success('This is a success message');
CustomLogger.warning('This is a warning message');
```

## Configuration Options

The library provides several configuration options, including:

- `setInfoPrefixAndSuffix`
- `setErrorPrefixAndSuffix`
- `setSuccessPrefixAndSuffix`
- `setWarningPrefixAndSuffix`
- `setLineBreaksAfterLog`
- `toggleCallerInfo`
- `setInfoTitle`
- `setErrorTitle`
- `setSuccessTitle`
- `setWarningTitle`
- and more...

Check the [API documentation](doc/api/index.html) for detailed information on available methods and their usage.

## Examples

For more advanced usage and specific scenarios, refer to the examples provided in the [`/example`](link/to/examples) directory.

## Issues and Feedback

Please report any issues or provide feedback on the [GitHub repository](link/to/github).

## License

This project is licensed under the [MIT License](link/to/license).