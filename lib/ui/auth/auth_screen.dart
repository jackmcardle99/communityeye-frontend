// import 'package:flutter/material.dart';
// import 'package:communityeye_frontend/ui/auth/auth_viewmodel.dart';
// import 'package:communityeye_frontend/ui/auth/login_screen.dart';
// import 'package:communityeye_frontend/ui/auth/register_screen.dart';
// import 'package:provider/provider.dart';

// class AuthScreen extends StatelessWidget {
//   const AuthScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final viewModel = Provider.of<AuthViewModel>(context);

//     return Scaffold(
//       appBar: AppBar(title: const Text('Authentication')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: viewModel.isLoading
//                   ? null
//                   : () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => const LoginScreen()),
//                       );
//                     },
//               child: const Text('Login'),
//             ),
//             ElevatedButton(
//               onPressed: viewModel.isLoading
//                   ? null
//                   : () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => const RegisterScreen()),
//                       );
//                     },
//               child: const Text('Register'),
//             ),
//             if (viewModel.errorMessage != null)
//               Text(
//                 viewModel.errorMessage!,
//                 style: const TextStyle(color: Colors.red),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:communityeye_frontend/ui/auth/auth_viewmodel.dart';
// import 'package:communityeye_frontend/ui/auth/login_screen.dart';
// import 'package:communityeye_frontend/ui/auth/register_screen.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// class AuthScreen extends StatelessWidget {
//   const AuthScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

//     return Scaffold(
      
//       body: Center(
//         child: isSmallScreen
//             ? const Column(
//                 children: [
//                   Spacer(), // Takes up available space above the logo
//                   Spacer(), // Takes up additional space to push content down
//                   _Logo(),
//                   SizedBox(height: 32), // Space between logo and buttons
//                   _AuthButtons(),
//                   Spacer(), // Takes up remaining space below the buttons
//                 ],
//               )
//             : Container(
//                 padding: const EdgeInsets.all(32.0),
//                 constraints: const BoxConstraints(maxWidth: 800),
//                 child: const Row(
//                   children: [
//                     Expanded(
//                       child: Column(
//                         children: [
//                           Spacer(),
//                           Spacer(),
//                           _Logo(),
//                         ],
//                       ),
//                     ),
//                     Expanded(
//                       child: Center(
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Spacer(),
//                             Spacer(),
//                             _AuthButtons(),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//       ),
//     );
//   }
// }

// class _Logo extends StatelessWidget {
//   const _Logo({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         SvgPicture.asset(
//           'lib/images/communityeye.svg',
//           width: isSmallScreen ? 100 : 200,
//           height: isSmallScreen ? 100 : 200,
//         ),
//         Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Text(
//             "Welcome to Community Eye!",
//             textAlign: TextAlign.center,
//             style: isSmallScreen
//                 ? Theme.of(context).textTheme.headlineSmall
//                 : Theme.of(context)
//                     .textTheme
//                     .headlineMedium
//                     ?.copyWith(color: Colors.black),
//           ),
//         )
//       ],
//     );
//   }
// }

// class _AuthButtons extends StatelessWidget {
//   const _AuthButtons();

//   @override
//   Widget build(BuildContext context) {
//     final viewModel = Provider.of<AuthViewModel>(context);

//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         SizedBox(
//           width: 200, // Fixed width for the buttons
//           child: ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(4)),
//             ),
//             onPressed: viewModel.isLoading
//                 ? null
//                 : () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => const LoginScreen()),
//                     );
//                   },
//             child: const Padding(
//               padding: EdgeInsets.all(10.0),
//               child: Text(
//                 'Login',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(height: 16),
//         SizedBox(
//           width: 200, // Fixed width for the buttons
//           child: ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(4)),
//             ),
//             onPressed: viewModel.isLoading
//                 ? null
//                 : () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => const RegisterScreen()),
//                     );
//                   },
//             child: const Padding(
//               padding: EdgeInsets.all(10.0),
//               child: Text(
//                 'Register',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ),
//         ),
//         if (viewModel.errorMessage != null)
//           Padding(
//             padding: const EdgeInsets.only(top: 16.0),
//             child: Text(
//               viewModel.errorMessage!,
//               style: const TextStyle(color: Colors.red),
//             ),
//           ),
//       ],
//     );
//   }
// }





// import 'package:communityeye_frontend/ui/widgets/button.dart';
// import 'package:communityeye_frontend/ui/widgets/logo.dart';
// import 'package:flutter/material.dart';
// import 'package:communityeye_frontend/ui/auth/login_screen.dart';
// import 'package:communityeye_frontend/ui/auth/register_screen.dart';

// class AuthScreen extends StatelessWidget {
//   const AuthScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

//     return Scaffold(
//       body: Center(
//         child: isSmallScreen
//             ? Column(
//                 children: [
//                   const Spacer(),
//                   const Spacer(),
//                   const Logo(),
//                   const SizedBox(height: 32),
//                   AppButton(
//                     text: 'Login',
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const LoginScreen(),
//                         ),
//                       );
//                     },
//                   ),
//                   const SizedBox(height: 16),
//                   AppButton(
//                     text: 'Register',
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const RegisterScreen(),
//                         ),
//                       );
//                     },
//                   ),
//                   const Spacer(),
//                 ],
//               )
//             : Container(
//                 padding: const EdgeInsets.all(32.0),
//                 constraints: const BoxConstraints(maxWidth: 800),
//                 child: Row(
//                   children: [
//                     const Expanded(
//                       child: Column(
//                         children: [
//                           Spacer(),
//                           Spacer(),
//                           Logo(),
//                         ],
//                       ),
//                     ),
//                     Expanded(
//                       child: Center(
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             AppButton(
//                               text: 'Login',
//                               onPressed: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => const LoginScreen(),
//                                   ),
//                                 );
//                               },
//                             ),
//                             const SizedBox(height: 16),
//                             AppButton(
//                               text: 'Register',
//                               onPressed: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => const RegisterScreen(),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//       ),
//     );
//   }
// }


import 'package:communityeye_frontend/ui/widgets/button.dart';
import 'package:communityeye_frontend/ui/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:communityeye_frontend/ui/auth/login_screen.dart';
import 'package:communityeye_frontend/ui/auth/register_screen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          double topPadding = constraints.minHeight * 0.66; // Start at 66% of screen height

          return Center(
            child: Padding(
              padding: EdgeInsets.only(top: topPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Logo(),
                  const SizedBox(height: 32),
                  AppButton(
                    text: 'Login',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  AppButton(
                    text: 'Register',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
