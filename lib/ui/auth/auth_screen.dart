// import 'package:flutter/material.dart';
// import 'package:communityeye_frontend/data/model/user.dart';
// import 'package:communityeye_frontend/ui/auth/auth_presenter.dart';

// class AuthScreen extends StatelessWidget {
//   final AuthPresenter presenter;

//   AuthScreen({required this.presenter});

//   @override
//   Widget build(BuildContext context) {
//     final emailController = TextEditingController();
//     final passwordController = TextEditingController();

//     return Scaffold(
//       appBar: AppBar(title: Text('Login/Register')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: emailController,
//               decoration: InputDecoration(labelText: 'Email'),
//             ),
//             TextField(
//               controller: passwordController,
//               decoration: InputDecoration(labelText: 'Password'),
//               obscureText: true,
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () async {
//                 final token = await presenter.loginUser(
//                   emailController.text,
//                   passwordController.text,
//                 );
//                 if (token != null) {
//                   // Handle successful login
//                 } else {
//                   // Handle login error
//                 }
//               },
//               child: Text('Login'),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 final user = User(
//                   firstName: 'John',
//                   lastName: 'Doe',
//                   email: emailController.text,
//                   mobileNumber: '1234567890',
//                   city: 'Sample City',
//                   password: passwordController.text,
//                 );
//                 final token = await presenter.registerUser(user);
//                 if (token != null) {
//                   // Handle successful registration
//                 } else {
//                   // Handle registration error
//                 }
//               },
//               child: Text('Register'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
