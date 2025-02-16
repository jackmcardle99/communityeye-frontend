import 'package:communityeye_frontend/ui/auth/auth_viewmodel.dart';
import 'package:communityeye_frontend/ui/home/home_screen.dart';
import 'package:communityeye_frontend/ui/map/reports_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:communityeye_frontend/ui/auth/auth_screen.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthViewModel()),
        ChangeNotifierProvider(create: (context) => ReportsViewModel()),
      ],
      child: MaterialApp(
        home: AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isAuthenticated) {
          return HomeScreen(); // Navigate to HomeScreen if token exists
        } else {
          return const AuthScreen(); // Show AuthScreen if no token
        }
      },
    );
  }
}
