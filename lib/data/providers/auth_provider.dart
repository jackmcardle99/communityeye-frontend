import 'package:communityeye_frontend/data/services/auth_service.dart';
import 'package:communityeye_frontend/data/model/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService;
  final FlutterSecureStorage _storage;
  bool _isAuthenticated = false;
  int? _userId;

  AuthProvider(this._authService, this._storage) {
    _checkAuthentication();
  }


  bool get isAuthenticated => _isAuthenticated;
  int? get userId => _userId;

  Future<void> _checkAuthentication() async {
    String? token = await getToken();
    if (token != null) {
      final decodedToken = JWT.decode(token);
      _userId = decodedToken.payload['id'];  // Store user ID
      _isAuthenticated = true;
      notifyListeners();
    } else {
      _isAuthenticated = false;
      _userId = null;  // Clear user ID
      notifyListeners();
    }
  }

  // Authentication
  Future<String?> register(User user) async {
    String? token = await _authService.register(user);
    if (token != null) {
      await _storage.write(key: 'jwt_token', value: token);
      final tokenData = JWT.decode(token);
      _userId = tokenData.payload['id'];  // Store user ID
      _isAuthenticated = true;
      notifyListeners();
    }
    return token;
  }

  Future<String?> login(String email, String password) async {
    String? token = await _authService.login(email, password);
    print("1");
    if (token != null) {
      await _storage.write(key: 'jwt_token', value: token);
      print("2");
      final tokenData = JWT.decode(token);
      print(tokenData.payload['id']);
      _userId = tokenData.payload['id'];  // Store user ID
      print("4");
      _isAuthenticated = true;
      print("5");
      notifyListeners();
    }
    print("6");
    return token;
  }

  Future<void> deleteUserAccount() async {
    String? token = await getToken();
    if (token != null) {
      await _authService.deleteUserAccount(token);
      await _storage.delete(key: 'jwt_token');
      _isAuthenticated = false;
      _userId = null;  // Clear user ID
      notifyListeners();
    }
  }

   Future<String?> getToken() async {
    String? token = await _storage.read(key: 'jwt_token');
    if (token != null) {
      try {
        final decodedToken = JWT.decode(token);
        final exp = decodedToken.payload['exp'];
        if (exp != null) {
          final expiryDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
          if (expiryDate.isBefore(DateTime.now())) {
            await deleteToken();
            return null;
          }
        }
        return token;
      } catch (_) {
        await deleteToken();
        return null;
      }
    }
    return null;
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: 'jwt_token');
    _isAuthenticated = false;
    _userId = null;  // Clear user ID
    notifyListeners();
  }

  // Get User ID without decoding the token again
  int? getCurrentUserId() {
    return _userId;
  }

  // Fetch user data
  Future<User?> fetchUser(int userId) async {
    String? token = await getToken();
    if (token != null) {
      return await _authService.fetchUser(userId, token);
    }
    return null;
  }
}
