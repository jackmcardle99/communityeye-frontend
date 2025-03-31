import 'package:communityeye_frontend/ui/auth/auth_screen.dart';
import 'package:communityeye_frontend/ui/widgets/button.dart'; // Import the AppButton widget
import 'package:communityeye_frontend/ui/widgets/button_danger.dart'; // Import the ButtonDanger widget
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:communityeye_frontend/ui/profile/profile_viewmodel.dart';
import 'package:communityeye_frontend/ui/widgets/error_message.dart';
import 'package:communityeye_frontend/ui/widgets/success_message.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileNumberController = TextEditingController();
  final cityController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileViewModel>().fetchUserProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileViewModel = Provider.of<ProfileViewModel>(context);

    if (profileViewModel.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (profileViewModel.errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Text(profileViewModel.errorMessage!),
        ),
      );
    }

    final user = profileViewModel.user;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('User not found or not authenticated')),
      );
    }

    firstNameController.text = user.firstName!;
    lastNameController.text = user.lastName!;
    emailController.text = user.email!;
    mobileNumberController.text = user.mobileNumber ?? '';
    cityController.text = user.city ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTextField(
                  controller: firstNameController,
                  label: 'First Name',
                  hint: 'Enter your first name',
                  icon: Icons.person_outline,
                  enabled: _isEditing,
                ),
                _gap(),
                _buildTextField(
                  controller: lastNameController,
                  label: 'Last Name',
                  hint: 'Enter your last name',
                  icon: Icons.person_outline,
                  enabled: _isEditing,
                ),
                _gap(),
                _buildTextField(
                  controller: emailController,
                  label: 'Email',
                  hint: 'Enter your email',
                  icon: Icons.email_outlined,
                  enabled: _isEditing,
                ),
                _gap(),
                _buildTextField(
                  controller: mobileNumberController,
                  label: 'Mobile Number',
                  hint: 'Enter your mobile number',
                  icon: Icons.phone_outlined,
                  enabled: _isEditing,
                ),
                _gap(),
                _buildTextField(
                  controller: cityController,
                  label: 'City',
                  hint: 'Enter your city',
                  icon: Icons.location_city_outlined,
                  enabled: _isEditing,
                ),
                _gap(),
                _buildTextField(
                  controller: passwordController,
                  label: 'Enter a new password',
                  hint: 'Enter a new password',
                  icon: Icons.lock_outline_rounded,
                  obscureText: true,
                  enabled: _isEditing,
                ),
                const SizedBox(height: 20),
                AppButton(
                  text: _isEditing ? 'Save' : 'Edit Profile',
                  onPressed: () async {
                    if (_isEditing) {
                      // Save profile changes when in edit mode
                      if (_formKey.currentState?.validate() ?? false) {
                        bool success = await profileViewModel.updateUserProfile(
                          firstNameController.text,
                          lastNameController.text,
                          emailController.text,
                          mobileNumberController.text,
                          cityController.text,
                          passwordController.text,
                        );
                        if (success) {
                          setState(() {
                            _isEditing = false; // Disable editing after save
                          });
                          // Show success snackbar
                          TopSnackBarSuccess.show(context, 'Profile updated successfully');
                        } else {
                          // Show error snackbar
                          TopSnackBarError.show(context, 'Failed to update profile');
                        }
                      }
                    } else {
                      setState(() {
                        _isEditing = true; // Enable editing
                      });
                    }
                  },
                ),
                const SizedBox(height: 8),
                AppButton(
                  text: 'Logout',
                  onPressed: () async {
                    await profileViewModel.logout();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const AuthScreen()),
                      (Route<dynamic> route) => false,
                    );
                  },
                ),
                const SizedBox(height: 8),
                ButtonDanger(
                  onPressed: () async {
                    await profileViewModel.deleteUserAccount();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const AuthScreen()),
                      (Route<dynamic> route) => false,
                    );
                  },
                  text: 'Delete Profile',
                ),
              ],
            ),
          ),
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
    bool obscureText = false,
    bool enabled = true,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
    );
  }
}
