// import 'package:communityeye_frontend/ui/home/home_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:communityeye_frontend/ui/auth/auth_viewmodel.dart';
// import 'package:provider/provider.dart';

// class LoginScreen extends StatelessWidget {
//   const LoginScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final viewModel = Provider.of<AuthViewModel>(context);

//     final formKey = GlobalKey<FormState>();
//     final emailController = TextEditingController();
//     final passwordController = TextEditingController();

//     return Scaffold(
//       appBar: AppBar(title: const Text('Login')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: emailController,
//                 decoration: const InputDecoration(labelText: 'Email'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your email';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: passwordController,
//                 decoration: const InputDecoration(labelText: 'Password'),
//                 obscureText: true,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your password';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 20),
//               viewModel.isLoading
//                   ? const CircularProgressIndicator()
//                   : ElevatedButton(
//                       onPressed: () async {
//                         if (formKey.currentState?.validate() ?? false) {
//                           await context.read<AuthViewModel>().login(
//                                 emailController.text,
//                                 passwordController.text,
//                               );

//                           if (viewModel.errorMessage == null) {
//                             Navigator.pushReplacement(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => const HomeScreen()),
//                             );
//                           } else {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(content: Text(viewModel.errorMessage!)),
//                             );
//                           }
//                         }
//                       },
//                       child: const Text('Login'),
//                     ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:communityeye_frontend/ui/home/home_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:communityeye_frontend/ui/auth/auth_viewmodel.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// class LoginScreen extends StatelessWidget {
//   const LoginScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

//     return Scaffold(
//       body: Center(
//         child: isSmallScreen
//             ? Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: const [
//                   _Logo(),
//                   _FormContent(),
//                 ],
//               )
//             : Container(
//                 padding: const EdgeInsets.all(32.0),
//                 constraints: const BoxConstraints(maxWidth: 800),
//                 child: Row(
//                   children: const [
//                     Expanded(child: _Logo()),
//                     Expanded(
//                       child: Center(child: _FormContent()),
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

// class _FormContent extends StatefulWidget {
//   const _FormContent({Key? key}) : super(key: key);

//   @override
//   State<_FormContent> createState() => __FormContentState();
// }

// class __FormContentState extends State<_FormContent> {
//   bool _isPasswordVisible = false;
//   bool _rememberMe = false;

//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     final viewModel = Provider.of<AuthViewModel>(context);

//     return Container(
//       constraints: const BoxConstraints(maxWidth: 300),
//       child: Form(
//         key: _formKey,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextFormField(
//               controller: emailController,
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter your email';
//                 }
//                 return null;
//               },
//               decoration: const InputDecoration(
//                 labelText: 'Email',
//                 hintText: 'Enter your email',
//                 prefixIcon: Icon(Icons.email_outlined),
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             _gap(),
//             TextFormField(
//               controller: passwordController,
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter your password';
//                 }
//                 if (value.length < 6) {
//                   return 'Password must be at least 6 characters';
//                 }
//                 return null;
//               },
//               obscureText: !_isPasswordVisible,
//               decoration: InputDecoration(
//                 labelText: 'Password',
//                 hintText: 'Enter your password',
//                 prefixIcon: const Icon(Icons.lock_outline_rounded),
//                 border: const OutlineInputBorder(),
//                 suffixIcon: IconButton(
//                   icon: Icon(_isPasswordVisible
//                       ? Icons.visibility_off
//                       : Icons.visibility),
//                   onPressed: () {
//                     setState(() {
//                       _isPasswordVisible = !_isPasswordVisible;
//                     });
//                   },
//                 ),
//               ),
//             ),
//             _gap(),
//             CheckboxListTile(
//               value: _rememberMe,
//               onChanged: (value) {
//                 if (value == null) return;
//                 setState(() {
//                   _rememberMe = value;
//                 });
//               },
//               title: const Text('Remember me'),
//               controlAffinity: ListTileControlAffinity.leading,
//               dense: true,
//               contentPadding: const EdgeInsets.all(0),
//             ),
//             _gap(),
//             SizedBox(
//               width: double.infinity,
//               child: viewModel.isLoading
//                   ? const CircularProgressIndicator()
//                   : ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(4)),
//                       ),
//                       child: const Padding(
//                         padding: EdgeInsets.all(10.0),
//                         child: Text(
//                           'Login',
//                           style: TextStyle(
//                               fontSize: 16, fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                       onPressed: () {
//                         if (_formKey.currentState?.validate() ?? false) {
//                           viewModel.login(
//                             emailController.text,
//                             passwordController.text,
//                           );
//                         }
//                       },
//                     ),
//             ),
//             if (viewModel.errorMessage != null)
//               Padding(
//                 padding: const EdgeInsets.only(top: 16.0),
//                 child: Text(
//                   viewModel.errorMessage!,
//                   style: const TextStyle(color: Colors.red),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _gap() => const SizedBox(height: 16);
// }
import 'package:communityeye_frontend/ui/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:communityeye_frontend/ui/auth/auth_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;
    

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: isSmallScreen
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  _Logo(),
                  _FormContent(),
                ],
              )
            : Container(
                padding: const EdgeInsets.all(32.0),
                constraints: const BoxConstraints(maxWidth: 800),
                child: Row(
                  children: const [
                    Expanded(child: _Logo()),
                    Expanded(
                      child: Center(child: _FormContent()),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          'lib/images/communityeye.svg',
          width: isSmallScreen ? 100 : 200,
          height: isSmallScreen ? 100 : 200,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Log into your account!",
            textAlign: TextAlign.center,
            style: isSmallScreen
                ? Theme.of(context).textTheme.headlineSmall
                : Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(color: Colors.black),
          ),
        )
      ],
    );
  }
}

class _FormContent extends StatefulWidget {
  const _FormContent({Key? key}) : super(key: key);

  @override
  State<_FormContent> createState() => __FormContentState();
}

class __FormContentState extends State<_FormContent> {
  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AuthViewModel>(context);

    // Listen for authentication state changes
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: emailController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            _gap(),
            TextFormField(
              controller: passwordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                border: const OutlineInputBorder(),
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
              ),
            ),
            _gap(),
            CheckboxListTile(
              value: _rememberMe,
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  _rememberMe = value;
                });
              },
              title: const Text('Remember me'),
              controlAffinity: ListTileControlAffinity.leading,
              dense: true,
              contentPadding: const EdgeInsets.all(0),
            ),
            _gap(),
            SizedBox(
              width: double.infinity,
              child: viewModel.isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'Login',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          viewModel.login(
                            emailController.text,
                            passwordController.text,
                          );
                        }
                      },
                    ),
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
}
