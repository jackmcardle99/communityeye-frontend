import 'package:get_it/get_it.dart';
import 'package:communityeye_frontend/data/services/auth_service.dart';
import 'package:communityeye_frontend/data/services/report_service.dart';
import 'package:communityeye_frontend/data/providers/auth_provider.dart';
import 'package:communityeye_frontend/data/providers/reports_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final getIt = GetIt.instance;

void setupLocator() {
  // registering services
  getIt.registerLazySingleton(() => AuthService());
  getIt.registerLazySingleton(() => ReportService());
  getIt.registerLazySingleton(() => const FlutterSecureStorage());

  // registering providers
  getIt.registerFactory(() => AuthProvider(getIt(), getIt()));
  getIt.registerFactory(() => ReportsProvider(getIt()));
}
