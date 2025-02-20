import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:communityeye_frontend/ui/auth/auth_viewmodel.dart';

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
      Provider.of<AuthViewModel>(context, listen: false).fetchCurrentUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final user = authViewModel.currentUser;

    // Show loading indicator while data is being fetched
    if (authViewModel.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Show error message if there was a problem fetching the user
    if (authViewModel.errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Text(authViewModel.errorMessage!),
        ),
      );
    }

    // If user is still null, show an appropriate message
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
              onPressed: () {
                // TODO: Implement logout logic
              },
              child: const Text('Logout'),
            ),
            TextButton(
              onPressed: () {
                // TODO: Implement delete profile logic
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
