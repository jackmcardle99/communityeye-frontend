/*
File: auth_viewmodel.dart
Author: Jack McArdle

This file is part of CommunityEye.

Email: mcardle-j9@ulster.ac.uk
B-No: B00733578
*/

import 'package:flutter/material.dart';
import 'package:communityeye_frontend/data/model/user.dart';
import 'package:communityeye_frontend/data/providers/auth_provider.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthProvider _authProvider;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isAuthenticated = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _isAuthenticated;

  AuthViewModel(AuthProvider authProvider) : _authProvider = authProvider {
    _authProvider.addListener(_onAuthChanged);
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    _isAuthenticated = _authProvider.isAuthenticated;
    notifyListeners();
  }

  // need this to listen for state changes to auth when logging otu
  void _onAuthChanged() {
    _isAuthenticated = _authProvider.isAuthenticated;
    notifyListeners();
  }

  Future<void> register(User user) async {
    _setLoadingState(true);
    _errorMessage = null;
    try {
      await _authProvider.register(user);
      _isAuthenticated = true;
    } catch (e) {
      _errorMessage = 'Registration failed: $e';
    } finally {
      _setLoadingState(false);
    }
  }

  Future<void> login(String email, String password) async {
    _setLoadingState(true);
    _errorMessage = null;

    try {
      await _authProvider.login(email, password);
      _isAuthenticated = true;
    } catch (e) {
      _errorMessage = 'Login failed: this email does not exist.';
    } finally {
      _setLoadingState(false);
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  void _setLoadingState(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }
}
