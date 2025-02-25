import 'dart:io';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

class LoggerService {
  static final LoggerService _instance = LoggerService._internal();
  static late Logger logger;

  factory LoggerService() {
    return _instance;
  }

  LoggerService._internal();

  Future<void> initializeLogger() async {
    final directory = await getApplicationDocumentsDirectory();
    final logDir = Directory('${directory.path}/logs');

    if (await logDir.exists() == false) {
      await logDir.create(recursive: true);
    }

    final logFile = File('${logDir.path}/local.log');
    logger = Logger(
      output: MultiOutput([
        ConsoleOutput(),
        FileOutput(file: logFile),
      ]),
      printer: PrettyPrinter(),
    );

    logger.i('Logger initialized successfully');
  }
}
