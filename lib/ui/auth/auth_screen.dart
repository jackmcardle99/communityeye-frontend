import 'package:flutter/material.dart';
import 'package:communityeye_frontend/ui/auth/auth_presenter.dart';
import 'package:communityeye_frontend/ui/auth/login_screen.dart';
import 'package:communityeye_frontend/ui/auth/register_screen.dart';
import 'package:communityeye_frontend/ui/auth/auth_viewmodel.dart';
import 'package:provider/provider.dart';

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
