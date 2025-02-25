import 'package:communityeye_frontend/data/services/auth_service.dart';
import 'package:communityeye_frontend/data/model/user.dart';
import 'package:communityeye_frontend/data/services/logger_service.dart';
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
    try {
      String? token = await getToken();
      if (token != null) {
        final decodedToken = JWT.decode(token);
        _userId = decodedToken.payload['user_id'];
        _isAuthenticated = true;
        LoggerService.logger.i('User is authenticated. User ID: $_userId');
      } else {
        _isAuthenticated = false;
        _userId = null;
        LoggerService.logger.i(
            'User is not authenticated and/or session has expired. Login required');
      }
      notifyListeners();
    } catch (e) {
      LoggerService.logger.e('Error checking authentication: $e');
      _isAuthenticated = false;
      _userId = null;
      notifyListeners();
    }
  }

  Future<String?> register(User user) async {
    try {
      String? token = await _authService.register(user);
      await _storage.write(key: 'jwt_token', value: token);
      final tokenData = JWT.decode(token);
      _userId = int.parse(tokenData.payload['user_id']);
      _isAuthenticated = true;
      LoggerService.logger
          .i('User registered and authenticated. User ID: $_userId');
      notifyListeners();
      return token;
    } catch (e) {
      LoggerService.logger.e('Registration error: $e');
      rethrow;
    }
  }

  Future<String?> login(String email, String password) async {
    try {
      String? token = await _authService.login(email, password);
      await _storage.write(key: 'jwt_token', value: token);
      final tokenData = JWT.decode(token);
      _userId = tokenData.payload['user_id'];
      _isAuthenticated = true;
      LoggerService.logger.i('User logged in. User ID: $_userId');
      notifyListeners();
      return token;
    } catch (e) {
      LoggerService.logger.e('Login error: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    int? userID = _userId;
    try {
      String? token = await getToken();
      if (token != null) {
        await _authService.logout(token);
        await deleteToken();
        LoggerService.logger.i('User logged out. User ID: $userID');
      }
    } catch (e) {
      LoggerService.logger.e('Logout error: $e');
    }
  }

  Future<void> deleteUserAccount() async {
    try {
      String? token = await getToken();
      if (token != null) {
        await _authService.deleteUserAccount(token);
        await deleteToken();
        LoggerService.logger.i('User account deleted. User ID: $_userId');
      }
    } catch (e) {
      LoggerService.logger.e('Error deleting user account: $e');
    }
  }

  Future<String?> getToken() async {
    try {
      String? token = await _storage.read(key: 'jwt_token');
      if (token != null) {
        final decodedToken = JWT.decode(token);
        final exp = decodedToken.payload['exp'];
        if (exp != null) {
          final expiryDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
          if (expiryDate.isBefore(DateTime.now())) {
            LoggerService.logger
                .w('Token expired for User ID: $_userId. Deleting token.');
            await deleteToken();
            return null;
          }
        }
        return token;
      }
      return null;
    } catch (e) {
      LoggerService.logger.e('Error retrieving token: $e');
      await deleteToken();
      return null;
    }
  }

  Future<void> deleteToken() async {
    try {
      await _storage.delete(key: 'jwt_token');
      _isAuthenticated = false;
      LoggerService.logger
          .i('Token deleted for User ID: $_userId. User is not authenticated.');
      _userId = null;
      notifyListeners();
    } catch (e) {
      LoggerService.logger.e('Error deleting token: $e');
    }
  }

  Future<User?> fetchUser(int userId) async {
    try {
      String? token = await getToken();
      if (token != null) {
        return await _authService.fetchUser(userId, token);
      }
      return null;
    } catch (e) {
      LoggerService.logger
          .e('Error fetching user data for User ID: $userId - Error: $e');
      return null;
    }
  }
}
