import 'dart:convert';
import 'package:communityeye_frontend/data/model/user.dart';
import 'package:communityeye_frontend/data/services/auth_service.dart';
import 'package:communityeye_frontend/data/services/logger_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import 'auth_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late AuthService authService;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    authService = AuthService();
  });

  group('AuthService Tests', () {
    group('register', () {
      test('returns a token if registration is successful (happy path)', () async {
        const token = 'mock_jwt_token';
        final user = User(
          firstName: "John",
          lastName: "Doe",
          email: "john.doe@example.com",
          mobileNumber: "+44 20 7123 1234",
          city: "London",
          password: "SecurePassword123!",
        );

        when(mockClient.post(
          Uri.parse('http://192.168.0.143:5001/api/v1/register'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(user.toJson()),
        )).thenAnswer((_) async => http.Response('{"token": "$token"}', 201));

        final result = await authService.register(user);

        expect(result, equals(token));
      });

      test('throws an exception if registration fails (sad path)', () async {
        final user = User(
          firstName: "John",
          lastName: "Doe",
          email: "john.doe@example.com",
          mobileNumber: "+44 20 7123 1234",
          city: "London",
          password: "SecurePassword123!",
        );

        when(mockClient.post(
          Uri.parse('http://192.168.0.143:5001/api/v1/register'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(user.toJson()),
        )).thenAnswer((_) async => http.Response('Failed', 400));

        expectLater(authService.register(user), throwsException);
      });
    });

    group('login', () {
      test('returns a token if login is successful (happy path)', () async {
        const token = 'mock_jwt_token';
        const email = 'john.doe@example.com';
        const password = 'SecurePassword123!';

        when(mockClient.post(
          Uri.parse('http://192.168.0.143:5001/api/v1/login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email, 'password': password}),
        )).thenAnswer((_) async => http.Response('{"token": "$token"}', 200));

        final result = await authService.login(email, password);

        expect(result, equals(token));
      });

      test('throws an exception if login fails (sad path)', () async {
        const email = 'john.doe@example.com';
        const password = 'wrongpassword';

        when(mockClient.post(
          Uri.parse('http://192.168.0.143:5001/api/v1/login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email, 'password': password}),
        )).thenAnswer((_) async => http.Response('Failed', 400));

        expectLater(authService.login(email, password), throwsException);
      });
    });

    group('logout', () {
      test('returns true if logout is successful (happy path)', () async {
        const token = 'mock_jwt_token';

        when(mockClient.get(
          Uri.parse('http://192.168.0.143:5001/api/v1/logout'),
          headers: {'Content-Type': 'application/json', 'x-access-token': token},
        )).thenAnswer((_) async => http.Response('Logged out', 200));

        final result = await authService.logout(token);

        expect(result, isTrue);
      });

      test('throws an exception if logout fails (sad path)', () async {
        const token = 'mock_jwt_token';

        when(mockClient.get(
          Uri.parse('http://192.168.0.143:5001/api/v1/logout'),
          headers: {'Content-Type': 'application/json', 'x-access-token': token},
        )).thenAnswer((_) async => http.Response('Failed', 400));

        expectLater(authService.logout(token), throwsException);
      });
    });

    group('fetchUser', () {
      test('returns a user if fetch is successful (happy path)', () async {
        const token = 'mock_jwt_token';
        final user = User(
          firstName: "John",
          lastName: "Doe",
          email: "john.doe@example.com",
          mobileNumber: "+44 20 7123 1234",
          city: "London",
          password: "SecurePassword123!",
        );

        when(mockClient.get(
          Uri.parse('http://192.168.0.143:5001/api/v1/users/1'),
          headers: {'Content-Type': 'application/json', 'x-access-token': token},
        )).thenAnswer((_) async => http.Response(jsonEncode(user.toJson()), 200));

        final result = await authService.fetchUser(1, token);

        expect(result, equals(user));
      });

      test('throws an exception if fetch fails (sad path)', () async {
        const token = 'mock_jwt_token';

        when(mockClient.get(
          Uri.parse('http://192.168.0.143:5001/api/v1/users/1'),
          headers: {'Content-Type': 'application/json', 'x-access-token': token},
        )).thenAnswer((_) async => http.Response('Failed', 400));

        expectLater(authService.fetchUser(1, token), throwsException);
      });
    });

    group('updateUser', () {
      test('returns true if update is successful (happy path)', () async {
        const token = 'mock_jwt_token';
        final updatedData = {'email': 'new.email@example.com'};

        when(mockClient.put(
          Uri.parse('http://192.168.0.143:5001/api/v1/users/1'),
          headers: {'Content-Type': 'application/json', 'x-access-token': token},
          body: jsonEncode(updatedData),
        )).thenAnswer((_) async => http.Response('Updated', 200));

        final result = await authService.updateUser(1, updatedData, token);

        expect(result, isTrue);
      });

      test('returns false if update fails (sad path)', () async {
        const token = 'mock_jwt_token';
        final updatedData = {'email': 'new.email@example.com'};

        when(mockClient.put(
          Uri.parse('http://192.168.0.143:5001/api/v1/users/1'),
          headers: {'Content-Type': 'application/json', 'x-access-token': token},
          body: jsonEncode(updatedData),
        )).thenAnswer((_) async => http.Response('Failed', 400));

        final result = await authService.updateUser(1, updatedData, token);

        expect(result, isFalse);
      });
    });

    group('deleteUserAccount', () {
      test('does not throw if deletion is successful (happy path)', () async {
        const token = 'mock_jwt_token';

        when(mockClient.delete(
          Uri.parse('http://192.168.0.143:5001/api/v1/delete_account'),
          headers: {'Content-Type': 'application/json', 'x-access-token': token},
        )).thenAnswer((_) async => http.Response('Deleted', 204));

        await authService.deleteUserAccount(token);
      });

      test('throws an exception if deletion fails (sad path)', () async {
        const token = 'mock_jwt_token';

        when(mockClient.delete(
          Uri.parse('http://192.168.0.143:5001/api/v1/delete_account'),
          headers: {'Content-Type': 'application/json', 'x-access-token': token},
        )).thenAnswer((_) async => http.Response('Failed', 400));

        expectLater(authService.deleteUserAccount(token), throwsException);
      });
    });
  });
}
