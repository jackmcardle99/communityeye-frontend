/*
File: main.dart
Author: Jack McArdle

This file is part of CommunityEye.

Email: mcardle-j9@ulster.ac.uk
B-No: B00733578
*/

import 'package:communityeye_frontend/data/services/logger_service.dart';
import 'package:communityeye_frontend/ui/auth/auth_screen.dart';
import 'package:communityeye_frontend/ui/home/home_screen.dart';
import 'package:communityeye_frontend/data/providers/auth_provider.dart';
import 'package:communityeye_frontend/data/repositories/report_repository.dart';
import 'package:communityeye_frontend/data/repositories/user_repository.dart';
import 'package:communityeye_frontend/data/services/auth_service.dart';
import 'package:communityeye_frontend/data/services/report_service.dart';
import 'package:communityeye_frontend/ui/map/map_viewmodel.dart';
import 'package:communityeye_frontend/ui/auth/auth_viewmodel.dart';
import 'package:communityeye_frontend/ui/profile/profile_viewmodel.dart';
import 'package:communityeye_frontend/ui/reports/myreport_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LoggerService().initializeLogger();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => AuthService()),
        Provider(create: (_) => const FlutterSecureStorage()),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(
            Provider.of<AuthService>(context, listen: false),
            Provider.of<FlutterSecureStorage>(context, listen: false),

          ),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthViewModel(
            Provider.of<AuthProvider>(context, listen: false),
          ),
        ),
        Provider(create: (_) => ReportService()),
        ChangeNotifierProvider(
          create: (context) => ReportRepository(
            Provider.of<ReportService>(context, listen: false),
            Provider.of<AuthProvider>(context, listen: false)
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => ReportsViewModel(
            Provider.of<ReportRepository>(context, listen: false),
            Provider.of<AuthProvider>(context, listen: false),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => MyReportsViewModel(
            Provider.of<ReportRepository>(context, listen: false),
            Provider.of<AuthProvider>(context, listen: false),
          ),
        ),
        Provider(
          create: (context) => UserRepository(
            Provider.of<AuthProvider>(context, listen: false),
            Provider.of<AuthService>(context, listen: false)
          ),
        ),
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
        if (authProvider.isAuthenticated) {
          return const HomeScreen();
        } else {
          return const AuthScreen(); 
        }
      },
    );
  }
}
