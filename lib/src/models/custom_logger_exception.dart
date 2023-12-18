class CustomLoggerException implements Exception {
  final String title;
  final String detail;
  final String message;

  CustomLoggerException({required this.title, required this.detail, required this.message});
}