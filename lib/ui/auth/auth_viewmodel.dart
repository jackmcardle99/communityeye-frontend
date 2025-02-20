import 'package:communityeye_frontend/data/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:communityeye_frontend/data/model/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class AuthViewModel extends ChangeNotifier {
  
  final AuthService _authService = AuthService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  bool _isAuthenticated = false;
  User? _currentUser;
  bool _isLoading = false; 
  String? _errorMessage;
  
  // Getters
  bool get isAuthenticated => _isAuthenticated;
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  AuthViewModel() {
    _checkToken();
  }

  ///////////////////////////// AUTH METHODS  /////////////////////////////

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

    Future<void> deleteUserAccount() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    String? token = await getToken();
    if (token == null) {
      _errorMessage = 'No valid token found.';
      _isLoading = false;
      notifyListeners();
      return;
    }

    final deleteError = await _authService.deleteUserAccount(token);

    if (deleteError == null) {
      await deleteToken();
      _isLoading = false;
      notifyListeners();
    } else {
      _errorMessage = deleteError;
      _isLoading = false;
      notifyListeners();
    }
  }


///////////////////////////// USER METHODS  /////////////////////////////

Future<void> fetchCurrentUser() async {
    if (_currentUser != null) return; 

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    Map<String, dynamic>? tokenData = await getTokenData();

    if (tokenData == null) {
      _errorMessage = 'No valid token found.';
      _isLoading = false;
      notifyListeners();
      return;
    }

    if (!tokenData.containsKey('id')) {
      _errorMessage = 'Invalid token format.';
      _isLoading = false;
      notifyListeners();
      return;
    }

    String userId = tokenData['id'].toString();
    _currentUser = await _authService.fetchUser(userId);

    if (_currentUser == null) {
      _errorMessage = 'Failed to fetch user data.';
    }

    _isLoading = false;
    notifyListeners();
  }

///////////////////////////// TOKEN METHODS  /////////////////////////////

  Future<void> _checkToken() async {
    String? token = await getToken();
    _isAuthenticated = token != null;
    print(token);
    notifyListeners();
  }

  Future<String?> getToken() async {
    String? token = await _storage.read(key: 'jwt_token');
    
    if (token == null) {
      _isAuthenticated = false; 
      notifyListeners();
      return null;
    }

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
    } catch (e) {
      await deleteToken(); 
      return null;
    }
  }
  

  Future<Map<String, dynamic>?> getTokenData() async {
    String? token = await getToken();
    if (token == null) return null;

    try {
      
      final decodedToken = JWT.decode(token);
      return decodedToken.payload;
    } catch (e) {
      
      return null;
    }
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: 'jwt_token');
    _isAuthenticated = false;
    notifyListeners();
  }

// Future<void> fetchCurrentUser() async {
//     Map<String, dynamic>? tokenData = await getTokenData();
//     if (tokenData == null || !tokenData.containsKey('user_id')) return;

//     String userId = tokenData['user_id'].toString();
//     _currentUser = await _authService.fetchUser(userId);
//     notifyListeners();
//   }


// Future<void> fetchCurrentUser() async {
//   Map<String, dynamic>? tokenData = await getTokenData();

//   if (tokenData == null) {
//     print("Token data is null. User is not authenticated.");
//     return;
//   }

//   if (!tokenData.containsKey('id')) {
//     print("Token does not contain user_id.");
//     return;
//   }

//   String userId = tokenData['id'].toString();
//   print("Fetching user with ID: $userId");

//   _currentUser = await _authService.fetchUser(userId);
  
//   if (_currentUser == null) {
//     print("Failed to fetch user. Keeping _currentUser as null.");
//   } else {
//     print("Successfully fetched user: ${_currentUser!.firstName}");
//   }

//   notifyListeners();
// }





}
