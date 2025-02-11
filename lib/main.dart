// import 'package:communityeye_frontend/ui/map/reports_screen.dart';
// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: ReportsScreen(),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import 'ui/auth/auth_presenter.dart';
// import 'ui/auth/auth_screen.dart';
// import 'ui/auth/auth_viewmodel.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) => AuthViewModel(),
//       child: MaterialApp(
//         home: Consumer<AuthViewModel>(
//           builder: (context, viewModel, child) {
//             final presenter = AuthPresenter(viewModel);
//             return AuthScreen(presenter: presenter);
//           },
//         ),
//       ),
//     );
//   }
// }
import 'package:communityeye_frontend/ui/auth/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:communityeye_frontend/ui/auth/auth_presenter.dart';
import 'package:communityeye_frontend/ui/auth/login_screen.dart';
import 'package:communityeye_frontend/ui/auth/register_screen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthViewModel(),
      child: MaterialApp(
        home: AuthScreen(),
      ),
    );
  }
}

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AuthViewModel>(context);
    final presenter = AuthPresenter(viewModel);

    return Scaffold(
      appBar: AppBar(title: Text('Authentication')),
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
              child: Text('Login'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen(presenter: presenter)),
                );
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
