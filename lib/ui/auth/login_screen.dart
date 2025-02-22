import 'package:communityeye_frontend/ui/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:communityeye_frontend/ui/auth/auth_viewmodel.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AuthViewModel>(context);

    final _formKey = GlobalKey<FormState>();
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              viewModel.isLoading
                  ? const CircularProgressIndicator() // Show loading indicator while logging in
                  : ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          await viewModel.login(
                            _emailController.text,
                            _passwordController.text,
                          );

                          if (viewModel.errorMessage == null) {
                            // Navigate to the HomeScreen on successful login
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeScreen()),
                            );
                          } else {
                            // Show error message if login failed
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(viewModel.errorMessage!)),
                            );
                          }
                        }
                      },
                      child: const Text('Login'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
