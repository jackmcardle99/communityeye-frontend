import 'package:communityeye_frontend/data/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:communityeye_frontend/data/model/user.dart';
import 'package:communityeye_frontend/data/repositories/user_repository.dart';

class ProfileViewModel extends ChangeNotifier {
  final UserRepository _userRepository;
  final AuthProvider _authProvider;

  bool _isLoading = false;
  String? _errorMessage;
  User? _user;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get user => _user;

  ProfileViewModel(this._userRepository, this._authProvider);

  Future<void> fetchUserProfile() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    _user = await _userRepository.fetchUserProfile();
    if (_user == null) {
      _errorMessage = 'Failed to fetch user data';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> updateUserProfile(String firstName, String lastName) async {
    if (_user == null) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final updatedData = {
      'firstName': firstName,
      'lastName': lastName,
    };

    bool success = await _userRepository.updateUserProfile(updatedData);

    if (success) {
      _user = _user!.copyWith(firstName: firstName, lastName: lastName);
    } else {
      _errorMessage = 'Failed to update profile';
    }

    _isLoading = false;
    notifyListeners();
    return success;
  }

  Future<void> logout() async {
    await _authProvider.logout();
  }

  Future<void> deleteUserAccount() async {
    await _authProvider.deleteUserAccount();
  }
}
