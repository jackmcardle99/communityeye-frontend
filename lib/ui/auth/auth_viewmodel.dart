import 'package:communityeye_frontend/data/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:communityeye_frontend/data/model/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  
  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  AuthViewModel() {
    _checkToken();
  }

  Future<void> _checkToken() async {
    String? token = await getToken();
    _isAuthenticated = token != null;
    notifyListeners();
  }

  Future<String?> register(User user) async {
    String? token = await _authService.register(user);
    if (token != null) {
      await _storage.write(key: 'jwt_token', value: token);
      _isAuthenticated = true;
      notifyListeners();
    }
    return token;
  }

  Future<String?> login(String email, String password) async {
    String? token = await _authService.login(email, password);
    if (token != null) {
      await _storage.write(key: 'jwt_token', value: token);
      _isAuthenticated = true;
      notifyListeners();
    }
    return token;
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: 'jwt_token');
    _isAuthenticated = false;
    notifyListeners();
  }
}
