// import 'package:communityeye_frontend/ui/auth/auth_viewmodel.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:communityeye_frontend/ui/auth/auth_presenter.dart';
// import 'package:communityeye_frontend/ui/auth/login_screen.dart';
// import 'package:communityeye_frontend/ui/auth/register_screen.dart';


// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) => AuthViewModel(),
//       child: MaterialApp(
//         home: AuthScreen(),
//       ),
//     );
//   }
// }

// class AuthScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final viewModel = Provider.of<AuthViewModel>(context);
//     final presenter = AuthPresenter(viewModel);

//     return Scaffold(
//       appBar: AppBar(title: Text('Authentication')),
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
//               child: Text('Login'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => RegisterScreen(presenter: presenter)),
//                 );
//               },
//               child: Text('Register'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:communityeye_frontend/ui/auth/auth_viewmodel.dart';
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
        ChangeNotifierProvider(create: (context) => AuthViewModel()), // Auth provider
        ChangeNotifierProvider(create: (context) => ReportsViewModel()), // Reports provider
      ],
      child: const MaterialApp(
        home: AuthScreen(),
      ),
    );
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
