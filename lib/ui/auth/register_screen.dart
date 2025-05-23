/*
File: register_screen.dart
Author: Jack McArdle

This file is part of CommunityEye.

Email: mcardle-j9@ulster.ac.uk
B-No: B00733578
*/

import 'package:communityeye_frontend/ui/home/home_screen.dart';
import 'package:communityeye_frontend/ui/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:communityeye_frontend/data/model/user.dart';
import 'package:communityeye_frontend/ui/auth/auth_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:communityeye_frontend/ui/widgets/error_message.dart';
import 'package:communityeye_frontend/ui/widgets/success_message.dart';
import 'package:flutter/services.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
  bool _isConfirmPasswordVisible = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileNumberController = TextEditingController();
  final cityController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AuthViewModel>(context);

    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField(
              controller: firstNameController,
              label: 'First Name',
              hint: 'Enter your first name',
              icon: Icons.person,
              keyboardType: TextInputType.name,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]"))],
            ),
            _gap(),
            _buildTextField(
              controller: lastNameController,
              label: 'Last Name',
              hint: 'Enter your last name',
              icon: Icons.person,
              keyboardType: TextInputType.name,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]"))],
            ),
            _gap(),
            _buildTextField(
              controller: emailController,
              label: 'Email',
              hint: 'Enter your email',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            _gap(),
            _buildTextField(
              controller: mobileNumberController,
              label: 'Mobile Number',
              hint: 'Enter your mobile number',
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            _gap(),
            _buildTextField(
              controller: cityController,
              label: 'City',
              hint: 'Enter your city',
              icon: Icons.location_city,
              keyboardType: TextInputType.name,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]"))],
            ),
            _gap(),
            _buildTextField(
              controller: passwordController,
              label: 'Password',
              hint: 'Enter your password',
              icon: Icons.lock_outline_rounded,
              obscureText: !_isPasswordVisible,
              suffixIcon: IconButton(
                icon: Icon(_isPasswordVisible
                    ? Icons.visibility_off
                    : Icons.visibility),
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
            _buildTextField(
              controller: confirmPasswordController,
              label: 'Confirm Password',
              hint: 'Re-enter your password',
              icon: Icons.lock_outline_rounded,
              obscureText: !_isConfirmPasswordVisible,
              suffixIcon: IconButton(
                icon: Icon(_isConfirmPasswordVisible
                    ? Icons.visibility_off
                    : Icons.visibility),
                onPressed: () {
                  setState(() {
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                  });
                },
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Please confirm your password';
                if (value != passwordController.text) return 'Passwords do not match';
                return null;
              },
            ),
            _gap(),
            viewModel.isLoading
                ? const CircularProgressIndicator()
                : AppButton(
                    text: 'Register',
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        final user = User(
                          firstName: firstNameController.text,
                          lastName: lastNameController.text,
                          email: emailController.text,
                          mobileNumber: mobileNumberController.text,
                          city: cityController.text,
                          password: passwordController.text,
                        );
                        await context.read<AuthViewModel>().register(user);

                        if (viewModel.errorMessage == null) {
                          TopSnackBarSuccess.show(
                            context, 
                            'Registration successful!'
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const HomeScreen()),
                          );
                        } else {
                          TopSnackBarError.show(
                            context, 
                            viewModel.errorMessage!
                          );  
                        }
                      }
                    },
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
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
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
