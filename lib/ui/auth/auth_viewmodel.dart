import 'package:communityeye_frontend/data/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:communityeye_frontend/data/model/user.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  Future<String?> register(User user) async {
    return await _authService.register(user);
  }

  Future<String?> login(String email, String password) async {
    return await _authService.login(email, password);
  }
}
