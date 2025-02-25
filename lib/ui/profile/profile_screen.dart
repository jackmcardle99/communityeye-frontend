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
              enabled: false,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() => _isEditing = !_isEditing);
                // if (!_isEditing) {
                //   // Save changes if editing is turned off
                //   context.read<ProfileViewModel>().saveProfileChanges(
                //     user.copyWith(
                //       firstName: user.firstName,
                //       lastName: user.lastName,
                //     ),
                //   );
                // }
              },
              child: Text(_isEditing ? 'Save' : 'Edit Profile'),
            ),
            ElevatedButton(
              onPressed: () async {
                await context.read<ProfileViewModel>().logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthScreen()),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text('Logout'),
            ),
            TextButton(
              onPressed: () async {
                await context.read<ProfileViewModel>().deleteUserAccount();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthScreen()),
                  (Route<dynamic> route) => false,
                );
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
