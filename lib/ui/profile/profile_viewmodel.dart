import 'package:flutter/material.dart';
import 'package:communityeye_frontend/data/providers/auth_provider.dart';
import 'package:communityeye_frontend/data/model/user.dart';

class ProfileViewModel extends ChangeNotifier {
  final AuthProvider _authProvider;

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? _user;
  User? get user => _user;

  ProfileViewModel(this._authProvider);

  Future<void> fetchUserProfile() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // Get user data using the AuthProvider
    int? userId = _authProvider.getCurrentUserId();
    if (userId != null) {
      _user = await _authProvider.fetchUser(userId);
      if (_user == null) {
        _errorMessage = 'Failed to fetch user data';
      }
    } else {
      _errorMessage = 'User not authenticated';
    }

    _isLoading = false;
    notifyListeners();
  }
}
