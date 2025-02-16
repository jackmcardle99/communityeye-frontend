// import 'package:communityeye_frontend/ui/auth/auth_viewmodel.dart';
// import 'package:communityeye_frontend/ui/map/reports_viewmodel.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:communityeye_frontend/ui/auth/auth_presenter.dart';
// import 'package:communityeye_frontend/ui/auth/login_screen.dart';
// import 'package:communityeye_frontend/ui/auth/register_screen.dart';


// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (context) => AuthViewModel()), // Auth provider
//         ChangeNotifierProvider(create: (context) => ReportsViewModel()), // Reports provider
//       ],
//       child: const MaterialApp(
//         home: AuthScreen(),
//       ),
//     );
//   }
// }

// class AuthScreen extends StatelessWidget {
//   const AuthScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final viewModel = Provider.of<AuthViewModel>(context);
//     final presenter = AuthPresenter(viewModel);

//     return Scaffold(
//       appBar: AppBar(title: const Text('Authentication')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => LoginScreen(presenter: presenter)),
//                 );
//               },
//               child: const Text('Login'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => RegisterScreen(presenter: presenter)),
//                 );
//               },
//               child: const Text('Register'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:communityeye_frontend/ui/auth/auth_viewmodel.dart';
import 'package:communityeye_frontend/ui/home/home_screen.dart';
import 'package:communityeye_frontend/ui/map/reports_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:communityeye_frontend/ui/auth/auth_presenter.dart';
import 'package:communityeye_frontend/ui/auth/login_screen.dart';
import 'package:communityeye_frontend/ui/auth/register_screen.dart';

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
        home: FutureBuilder(
          future: checkTokenExists(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(); // Show a loading indicator
            } else {
              if (snapshot.data == true) {
                return HomeScreen(); // Navigate to HomeScreen if token exists
              } else {
                return AuthScreen(); // Show AuthScreen if no token
              }
            }
          },
        ),
      ),
    );
  }

  Future<bool> checkTokenExists(BuildContext context) async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    String? token = await authViewModel.getToken();
    return token != null;
  }
}

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AuthViewModel>(context);
    final presenter = AuthPresenter(viewModel);

    return Scaffold(
      appBar: AppBar(title: const Text('Authentication')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen(presenter: presenter)),
                );
              },
              child: const Text('Login'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen(presenter: presenter)),
                );
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
