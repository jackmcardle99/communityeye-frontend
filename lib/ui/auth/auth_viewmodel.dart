import 'package:flutter/material.dart';
import 'package:communityeye_frontend/data/model/user.dart';
import 'package:communityeye_frontend/data/providers/auth_provider.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthProvider _authProvider;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isAuthenticated = false;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _isAuthenticated;

  AuthViewModel(AuthProvider authProvider)
      : _authProvider = authProvider {
    _checkAuthentication();
  }

  // Check if user is authenticated (e.g., check if a token exists)
  Future<void> _checkAuthentication() async {
    _isAuthenticated = _authProvider.isAuthenticated;
    notifyListeners();
  }

  // Register user
  Future<void> register(User user) async {
    _setLoadingState(true);
    _errorMessage = null;
    try {
      await _authProvider.register(user);
      _isAuthenticated = true;  // Set authenticated to true after successful registration
    } catch (e) {
      _errorMessage = 'Registration failed: $e';
    } finally {
      _setLoadingState(false);
    }
  }

  // Login user
  Future<void> login(String email, String password) async {
    _setLoadingState(true);
    _errorMessage = null;
    
    try {
    
      await _authProvider.login(email, password);
    
      _isAuthenticated = true;  // Set authenticated to true after successful login
    } catch (e) {
      _errorMessage = 'Login failed: $e';
    } finally {
      _setLoadingState(false);
    }
  }

  // Set loading state
  void _setLoadingState(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }
}
