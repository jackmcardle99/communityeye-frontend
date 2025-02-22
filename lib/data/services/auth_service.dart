// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:communityeye_frontend/data/model/user.dart';
// import 'package:communityeye_frontend/data/providers/auth_provider.dart';

// class AuthService {
//   final String baseUrl = 'http://192.168.0.143:5001/api/v1/';
//   // final AuthProvider _authProvider;

//   // AuthService(this._authProvider);

//   Future<String?> register(User user) async {
//     try {
//       final response = await http.post(
//         Uri.parse('${baseUrl}register'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode(user.toJson()),
//       );

//       if (response.statusCode == 201) {
//         final data = jsonDecode(response.body);
//         print("Register successful: ${data['token']}");
//         return data['token'];
//       } else {
//         // Handle error responses
//         print('Registration failed with status: ${response.statusCode}');
//         return null;
//       }
//     } catch (e) {
//       // Handle network errors
//       print('Registration failed with error: $e');
//       return null;
//     }
//   }

//   Future<String?> login(String email, String password) async {
//     try {
//       final response = await http.post(
//         Uri.parse('${baseUrl}login'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'email': email, 'password': password}),
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         print("Login successful: ${data['token']}");
//         return data['token'];
//       } else {
//         // Handle error responses
//         print('Login failed with status: ${response.statusCode}');
//         return null;
//       }
//     } catch (e) {
//       // Handle network errors
//       print('Login failed with error: $e');
//       return null;
//     }
//   }

//   Future<User?> fetchUser(String userId) async {
//     String? token = await _authProvider.getToken();
//     if (token == null) return null;

//     try {
//       final response = await http.get(
//         Uri.parse('${baseUrl}users/$userId'),
//         headers: {
//           'Content-Type': 'application/json',
//           'x-access-token': token,
//         },
//       );
      
//       if (response.statusCode == 200) {      
//         final data = jsonDecode(response.body);
//         return User.fromJson(data);
//       } else {
//         print('Fetch user failed with status: ${response.statusCode}');
//         return null;
//       }
//     } catch (e) {
//       print('Fetch user failed with error: $e');
//       return null;
//     }
//   }

//   Future<String?> deleteUserAccount(String token) async {
//     try {
//       final response = await http.delete(
//         Uri.parse('${baseUrl}delete_account'),
//         headers: {
//           'Content-Type': 'application/json',
//           'x-access-token': token,
//         },
//       );

//       if (response.statusCode == 201) {
//         print("Account deleted successfully.");
//         return null;  // No error
//       } else {
//         print('Failed to delete account with status: ${response.statusCode}');
//         return 'Failed to delete account. Please try again.';
//       }
//     } catch (e) {
//       print('Error deleting account: $e');
//       return 'Error deleting account: $e';
//     }
//   }
// }
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:communityeye_frontend/data/model/user.dart';

class AuthService {
  final String baseUrl = 'http://192.168.0.143:5001/api/v1/';

  Future<String?> register(User user) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print("Register successful: ${data['token']}");
        return data['token'];
      } else {
        print('Registration failed with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Registration failed with error: $e');
      return null;
    }
  }

  Future<String?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Login successful: ${data['token']}");
        return data['token'];
      } else {
        print('Login failed with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Login failed with error: $e');
      return null;
    }
  }

  Future<User?> fetchUser(int userId, String token) async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}users/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'x-access-token': token,
        },
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return User.fromJson(data);
      } else {
        print('Fetch user failed with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Fetch user failed with error: $e');
      return null;
    }
  }

  Future<String?> deleteUserAccount(String token) async {
    try {
      final response = await http.delete(
        Uri.parse('${baseUrl}delete_account'),
        headers: {
          'Content-Type': 'application/json',
          'x-access-token': token,
        },
      );

      if (response.statusCode == 201) {
        print("Account deleted successfully.");
        return null;
      } else {
        print('Failed to delete account with status: ${response.statusCode}');
        return 'Failed to delete account. Please try again.';
      }
    } catch (e) {
      print('Error deleting account: $e');
      return 'Error deleting account: $e';
    }
  }
}
