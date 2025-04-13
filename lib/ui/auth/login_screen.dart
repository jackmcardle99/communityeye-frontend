/*
File: login_screen.dart
Author: Jack McArdle

This file is part of CommunityEye.

Email: mcardle-j9@ulster.ac.uk
B-No: B00733578
*/

import 'package:communityeye_frontend/ui/home/home_screen.dart';
import 'package:communityeye_frontend/ui/widgets/button.dart';
import 'package:communityeye_frontend/ui/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:communityeye_frontend/ui/auth/auth_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                top: constraints.maxHeight * 0.1, 
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Logo(),
                  SizedBox(height: 32),
                  _FormContent(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FormContent extends StatefulWidget {
  const _FormContent();

  @override
  State<_FormContent> createState() => __FormContentState();
}

class __FormContentState extends State<_FormContent> {
  bool _isPasswordVisible = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AuthViewModel>(context);

    if (viewModel.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      });
    }

    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField(
              controller: emailController,
              label: 'Email',
              hint: 'Enter your email',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            _gap(),
            _buildTextField(
              controller: passwordController,
              label: 'Password',
              hint: 'Enter your password',
              icon: Icons.lock_outline_rounded,
              obscureText: !_isPasswordVisible,
              suffixIcon: IconButton(
                icon: Icon(_isPasswordVisible ? Icons.visibility_off : Icons.visibility),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Please enter your password';
                if (value.length < 6) return 'Password must be at least 6 characters';
                return null;
              },
            ),
            _gap(),            
            _gap(),
            viewModel.isLoading
                ? const CircularProgressIndicator()
                : AppButton(
                    text: 'Login',
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        viewModel.login(
                          emailController.text,
                          passwordController.text,
                        );
                      }
                    },
                  ),
            if (viewModel.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  viewModel.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
    bool obscureText = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
        suffixIcon: suffixIcon,
      ),
       validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $label';
        }
        if (label == 'Email' && !context.read<AuthViewModel>().isValidEmail(value)) {
          return 'Please enter a valid email';
        }
        return validator?.call(value);
      },
    );
  }
}
