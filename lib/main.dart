// import 'package:communityeye_frontend/ui/auth/auth_screen.dart';
// import 'package:communityeye_frontend/ui/home/home_screen.dart';
// import 'package:communityeye_frontend/data/providers/auth_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:communityeye_frontend/data/services/auth_service.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// void main() {
//   final authProvider = AuthProvider(
//     AuthService(),
//     FlutterSecureStorage(),
//   );

//   runApp(MyApp(authProvider: authProvider));
// }

// class MyApp extends StatelessWidget {
//   final AuthProvider authProvider;

//   const MyApp({super.key, required this.authProvider});

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         // Provide the AuthProvider to the app
//         ChangeNotifierProvider(create: (_) => authProvider),
//       ],
//       child: const MaterialApp(
//         home: AuthWrapper(),
//       ),
//     );
//   }
// }

// class AuthWrapper extends StatelessWidget {
//   const AuthWrapper({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<AuthProvider>(
//       builder: (context, authProvider, child) {
//         // Use `authProvider` to determine the authentication state
//         if (authProvider.isAuthenticated) {
//           return const HomeScreen(); // Navigate to HomeScreen if authenticated
//         } else {
//           return const AuthScreen(); // Show AuthScreen if not authenticated
//         }
//       },
//     );
//   }
// }
// import 'package:communityeye_frontend/ui/auth/auth_screen.dart';
// import 'package:communityeye_frontend/ui/home/home_screen.dart';
// import 'package:communityeye_frontend/data/providers/auth_provider.dart';
// import 'package:communityeye_frontend/data/providers/reports_provider.dart';
// import 'package:communityeye_frontend/data/services/auth_service.dart';
// import 'package:communityeye_frontend/data/services/report_service.dart';
// import 'package:communityeye_frontend/ui/map/reports_viewmodel.dart';
// import 'package:communityeye_frontend/ui/auth/auth_viewmodel.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized(); // this ensures flutter binding is initialised before executing any code
//   final authProvider = AuthProvider(
//     AuthService(),
//     const FlutterSecureStorage(),
//   );

//   final reportService = ReportService(); // Create an instance of ReportService

//   runApp(MyApp(authProvider: authProvider, reportService: reportService));
// }

// class MyApp extends StatelessWidget {
//   final AuthProvider authProvider;
//   final ReportService reportService;

//   const MyApp({super.key, required this.authProvider, required this.reportService});

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         // Provide the AuthProvider to the app
//         ChangeNotifierProvider(create: (_) => authProvider),
//         // Provide the AuthViewModel to the app
//         ChangeNotifierProvider(create: (_) => AuthViewModel(authProvider)),
//         // Provide the ReportsProvider to the app with necessary arguments
//         ChangeNotifierProvider(create: (_) => ReportsProvider(reportService)),
//         // Provide the ReportService to the app using Provider
//         Provider(create: (_) => reportService),
//         // Provide the ReportsViewModel to the app
//         ChangeNotifierProvider(create: (context) => ReportsViewModel(
//           Provider.of<ReportService>(context, listen: false),
//           Provider.of<AuthProvider>(context, listen: false),
//         )),
//       ],
//       child: const MaterialApp(
//         home: AuthWrapper(),
//       ),
//     );
//   }
// }

// class AuthWrapper extends StatelessWidget {
//   const AuthWrapper({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<AuthProvider>(
//       builder: (context, authProvider, child) {
//         // Use `authProvider` to determine the authentication state
//         if (authProvider.isAuthenticated) {
//           return const HomeScreen(); // Navigate to HomeScreen if authenticated
//         } else {
//           return const AuthScreen(); // Show AuthScreen if not authenticated
//         }
//       },
//     );
//   }
// }
import 'package:communityeye_frontend/ui/auth/auth_screen.dart';
import 'package:communityeye_frontend/ui/home/home_screen.dart';
import 'package:communityeye_frontend/data/providers/auth_provider.dart';
import 'package:communityeye_frontend/data/providers/reports_provider.dart';
import 'package:communityeye_frontend/data/services/auth_service.dart';
import 'package:communityeye_frontend/data/services/report_service.dart';
import 'package:communityeye_frontend/ui/map/reports_viewmodel.dart';
import 'package:communityeye_frontend/ui/auth/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter binding is initialized
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
        // Provide the ReportsProvider to the app with necessary arguments
        ChangeNotifierProvider(
          create: (context) => ReportsProvider(
            Provider.of<ReportService>(context, listen: false),
          ),
        ),
        // Provide the ReportsViewModel to the app
        ChangeNotifierProvider(
          create: (context) => ReportsViewModel(
            Provider.of<ReportsProvider>(context, listen: false),
            Provider.of<AuthProvider>(context, listen: false),
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
