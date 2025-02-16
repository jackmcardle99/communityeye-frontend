import 'package:communityeye_frontend/ui/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:communityeye_frontend/data/model/user.dart';
import 'package:communityeye_frontend/ui/auth/auth_presenter.dart';
import 'package:communityeye_frontend/ui/auth/auth_presenter.dart';


class RegisterScreen extends StatelessWidget {
  final AuthPresenter presenter;

  RegisterScreen({required this.presenter});

  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileNumberController = TextEditingController();
  final _cityController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(labelText: 'First Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(labelText: 'Last Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _mobileNumberController,
                decoration: InputDecoration(labelText: 'Mobile Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your mobile number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _cityController,
                decoration: InputDecoration(labelText: 'City'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your city';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    final user = User(
                      firstName: _firstNameController.text,
                      lastName: _lastNameController.text,
                      email: _emailController.text,
                      mobileNumber: _mobileNumberController.text,
                      city: _cityController.text,
                      password: _passwordController.text,
                    );
                    final token = await presenter.registerUser(user);
                    if (token != null) {
                      // Navigate to ReportsScreen on successful registration
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    } else {
                      // Handle registration error
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Registration failed')),
                      );
                    }
                  }
                },
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
