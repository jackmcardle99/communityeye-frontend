import 'package:communityeye_frontend/data/services/logger_service.dart';
import 'package:communityeye_frontend/ui/auth/auth_screen.dart';
import 'package:communityeye_frontend/ui/home/home_screen.dart';
import 'package:communityeye_frontend/data/providers/auth_provider.dart';
import 'package:communityeye_frontend/data/repositories/report_repository.dart';
import 'package:communityeye_frontend/data/repositories/user_repository.dart'; // Import UserRepository
import 'package:communityeye_frontend/data/services/auth_service.dart';
import 'package:communityeye_frontend/data/services/report_service.dart';
import 'package:communityeye_frontend/ui/map/reports_viewmodel.dart';
import 'package:communityeye_frontend/ui/auth/auth_viewmodel.dart';
import 'package:communityeye_frontend/ui/profile/profile_viewmodel.dart'; // Import ProfileViewModel
import 'package:communityeye_frontend/ui/reports/myreport_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter binding is initialized
  await LoggerService().initializeLogger();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provide the AuthService and FlutterSecureStorage
        Provider(create: (_) => AuthService()),
        Provider(create: (_) => const FlutterSecureStorage()),
        // Provide the AuthProvider to the app
        ChangeNotifierProvider(
          create: (context) => AuthProvider(
            Provider.of<AuthService>(context, listen: false),
            Provider.of<FlutterSecureStorage>(context, listen: false),

          ),
        ),
        // Provide the AuthViewModel to the app
        ChangeNotifierProvider(
          create: (context) => AuthViewModel(
            Provider.of<AuthProvider>(context, listen: false),
          ),
        ),
        // Provide the ReportService to the app
        Provider(create: (_) => ReportService()),
        // Provide the ReportRepository to the app with necessary arguments
        ChangeNotifierProvider(
          create: (context) => ReportRepository(
            Provider.of<ReportService>(context, listen: false),
            Provider.of<AuthProvider>(context, listen: false)
          ),
        ),
        // Provide the ReportsViewModel to the app
        ChangeNotifierProvider(
          create: (context) => ReportsViewModel(
            Provider.of<ReportRepository>(context, listen: false),
            Provider.of<AuthProvider>(context, listen: false),
          ),
        ),
         // Provide the MyReportsViewModel to the app
        ChangeNotifierProvider(
          create: (context) => MyReportsViewModel(
            Provider.of<ReportRepository>(context, listen: false),
            Provider.of<AuthProvider>(context, listen: false),
          ),
        ),
        // Provide the UserRepository to the app
        Provider(
          create: (context) => UserRepository(
            Provider.of<AuthProvider>(context, listen: false),
          ),
        ),
        // Provide the ProfileViewModel to the app
        ChangeNotifierProvider(
          create: (context) => ProfileViewModel(
            Provider.of<UserRepository>(context, listen: false),
            Provider.of<AuthProvider>(context, listen: false)
          ),
        ),
      ],
      child: const MaterialApp(
        home: AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Use `authProvider` to determine the authentication state
        if (authProvider.isAuthenticated) {
          return const HomeScreen(); // Navigate to HomeScreen if authenticated
        } else {
          return const AuthScreen(); // Show AuthScreen if not authenticated
        }
      },
    );
  }
}
