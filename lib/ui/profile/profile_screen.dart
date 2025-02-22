import 'package:communityeye_frontend/data/providers/auth_provider.dart';
import 'package:communityeye_frontend/ui/auth/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:communityeye_frontend/ui/profile/profile_viewmodel.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileViewModel = Provider.of<ProfileViewModel>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      if (authProvider.getToken() != null) {
        profileViewModel.fetchUserProfile(); // Fetch profile data
      } else {
        // Handle case where the user is not authenticated
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AuthScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileViewModel = Provider.of<ProfileViewModel>(context);
    final authProvider = Provider.of<AuthProvider>(context);

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

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              initialValue: user.firstName,
              decoration: const InputDecoration(labelText: 'First Name'),
              enabled: _isEditing,
            ),
            TextFormField(
              initialValue: user.lastName,
              decoration: const InputDecoration(labelText: 'Last Name'),
              enabled: _isEditing,
            ),
            TextFormField(
              initialValue: user.email,
              decoration: const InputDecoration(labelText: 'Email'),
              enabled: false, // Email shouldn't be editable
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() => _isEditing = !_isEditing);
              },
              child: Text(_isEditing ? 'Save' : 'Edit Profile'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Trigger logout using AuthProvider
                await authProvider.deleteToken();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthScreen()),
                );
              },
              child: const Text('Logout'),
            ),
            TextButton(
              onPressed: () async {
                // Trigger the delete account functionality using AuthProvider
                await authProvider.deleteUserAccount();

                if (authProvider.getToken() == null) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const AuthScreen()),
                    (Route<dynamic> route) => false,
                  );
                }
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
