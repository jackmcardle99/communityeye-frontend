import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:communityeye_frontend/data/model/user.dart';
import 'package:communityeye_frontend/data/services/logger_service.dart';

class AuthService {
  final String baseUrl = 'http://192.168.0.143:5001/api/v1/';
  // final String baseUrl = 'http://172.17.67.182:5000/api/v1/';

  Future<String> register(User user) async {
    try {
      final response =
          await http.post(Uri.parse('${baseUrl}register'), headers
                          : {'Content-Type' : 'application/json'}, body
                          : jsonEncode(user.toJson()), );

      LoggerService.logger.i('API Call: POST ${baseUrl}register - Status Code: ${response.statusCode} ${response.reasonPhrase} ${response.body}');


      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['token'];
      } else {
        throw Exception(
            'Registration failed with status: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> login(String email, String password) async {
    try {
      final response = await http.post(
          Uri.parse('${baseUrl}login'), headers
          : {'Content-Type' : 'application/json'}, body
          : jsonEncode({'email' : email, 'password' : password}), );

      LoggerService.logger.i('API Call: POST ${baseUrl}login - Status Code: ${response.statusCode} ${response.reasonPhrase} ${response.body}');


      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['token'];
      } else {
        throw Exception('Login failed with status: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> logout(String token) async {
    try {
      final response = await http.get(Uri.parse('${baseUrl}logout'), headers
                                      : {
                                        'Content-Type' : 'application/json',
                                        'x-access-token' : token,
                                      }, );

     LoggerService.logger.i('API Call: GET ${baseUrl}logout - Status Code: ${response.statusCode} ${response.reasonPhrase} ${response.body}');


      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Logout failed with status: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<User> fetchUser(int userId, String token) async {
    try {
      final response =
          await http.get(Uri.parse('${baseUrl}users/$userId'), headers
                         : {
                           'Content-Type' : 'application/json',
                           'x-access-token' : token,
                         }, );

      LoggerService.logger.i('API Call: GET ${baseUrl}users/$userId - Status Code: ${response.statusCode} ${response.reasonPhrase} ${response.body}');


      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return User.fromJson(data);
      } else {
        throw Exception(
            'Fetch user failed with status: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> updateUser(int userId, Map<String, dynamic> updatedData, String token) async {
    try {
      final response = await http.put(
        Uri.parse('${baseUrl}users/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'x-access-token': token,
        },
        body: jsonEncode(updatedData),
      );

      LoggerService.logger.i('API Call: PUT ${baseUrl}users/$userId - Status Code: ${response.statusCode} ${response.reasonPhrase} ${response.body}');

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Update failed with status: ${response.statusCode}');
      }
    } catch (e) {
      LoggerService.logger.e('Error updating user: $e');
      return false;
    }
  }

  Future<void> deleteUserAccount(String token) async {
    try {
      final response =
          await http.delete(Uri.parse('${baseUrl}delete_account'), headers
                            : {
                              'Content-Type' : 'application/json',
                              'x-access-token' : token,
                            }, );

      LoggerService.logger.i('API Call: DELETE ${baseUrl}delete_account - Status Code: ${response.statusCode} ${response.reasonPhrase} ${response.body}');

      if (response.statusCode == 204) {
      } else {
        throw Exception(
            'Failed to delete account with status: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
