// import 'package:flutter/material.dart';
// import 'package:communityeye_frontend/ui/auth/auth_presenter.dart';

// class LoginScreen extends StatelessWidget {
//   final AuthPresenter presenter;

//   LoginScreen({required this.presenter});

//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Login')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: _emailController,
//                 decoration: InputDecoration(labelText: 'Email'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your email';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _passwordController,
//                 decoration: InputDecoration(labelText: 'Password'),
//                 obscureText: true,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your password';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () async {
//                   if (_formKey.currentState?.validate() ?? false) {
//                     final token = await presenter.loginUser(
//                       _emailController.text,
//                       _passwordController.text,
//                     );
//                     if (token != null) {
//                       // Handle successful login
//                     } else {
//                       // Handle login error
//                     }
//                   }
//                 },
//                 child: Text('Login'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:communityeye_frontend/ui/map/reports_screen.dart';
import 'package:flutter/material.dart';
import 'package:communityeye_frontend/ui/auth/auth_presenter.dart';

class LoginScreen extends StatelessWidget {
  final AuthPresenter presenter;

  LoginScreen({required this.presenter});

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
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
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    final token = await presenter.loginUser(
                      _emailController.text,
                      _passwordController.text,
                    );
                    if (token != null) {
                      // Navigate to ReportsScreen on successful login
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => ReportsScreen()),
                      );
                    } else {
                      // Handle login error
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Login failed')),
                      );
                    }
                  }
                },
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
