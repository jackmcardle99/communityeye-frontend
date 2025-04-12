/*
File: auth_provider_test.dart
Author: Jack McArdle

This file is part of CommunityEye.

Email: mcardle-j9@ulster.ac.uk
B-No: B00733578
*/

import 'package:communityeye_frontend/data/model/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:communityeye_frontend/data/services/logger_service.dart';
import 'package:mockito/annotations.dart';
import 'package:communityeye_frontend/data/services/auth_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mockito/mockito.dart';
import 'auth_provider_test.mocks.dart';
import 'package:communityeye_frontend/data/providers/auth_provider.dart';

@GenerateMocks([AuthService, FlutterSecureStorage, LoggerService])
void main() {
  group('AuthProvider Tests', () {
    late AuthProvider authProvider;
    late MockLoggerService mockLoggerService;
    late MockAuthService mockAuthService;
    late MockFlutterSecureStorage mockStorage;

    setUp(() {
      mockAuthService = MockAuthService();
      mockStorage = MockFlutterSecureStorage();
      mockLoggerService = MockLoggerService();
      authProvider = AuthProvider(mockAuthService, mockStorage);
    });

    group('register', () {
      test('returns a token if registration is successful', () async {
        const token = 'mock_jwt_token';
        final user = User(
          firstName: "John",
          lastName: "Doe",
          email: "john.doe@example.com",
          mobileNumber: "+44 20 7123 1234",
          city: "London",
          password: "SecurePassword123!",
        );

        when(mockAuthService.register(user)).thenAnswer((_) async => token);
        when(mockStorage.write(key: 'jwt_token', value: token)).thenAnswer((_) async {});

        final result = await authProvider.register(user);

        expect(result, equals(token));
        verify(mockStorage.write(key: 'jwt_token', value: token)).called(1);
      });

      test('throws an exception if password is too short', () async {
        final invalidUser = User(
          firstName: "John",
          lastName: "Doe",
          email: "john.doe@example.com",
          mobileNumber: "+44 20 7123 1234",
          city: "London",
          password: "short",
        );

        when(mockAuthService.register(invalidUser)).thenThrow(Exception());

        expect(() => authProvider.register(invalidUser), throwsException);
      });

      test('handles registration with special characters in email', () async {
        const token = 'mock_jwt_token';
        final user = User(
          firstName: "John",
          lastName: "Doe",
          email: "john.doe+test@example.com",
          mobileNumber: "+44 20 7123 1234",
          city: "London",
          password: "SecurePassword123!",
        );

        when(mockAuthService.register(user)).thenAnswer((_) async => token);
        when(mockStorage.write(key: 'jwt_token', value: token)).thenAnswer((_) async {});

        final result = await authProvider.register(user);

        expect(result, equals(token));
        verify(mockStorage.write(key: 'jwt_token', value: token)).called(1);
      });
    });

    group('login', () {
      test('returns a token if login is successful', () async {
        const token = 'mock_jwt_token';
        const email = 'john.doe@example.com';
        const password = 'SecurePassword123!';

        when(mockAuthService.login(email, password)).thenAnswer((_) async => token);
        when(mockStorage.write(key: 'jwt_token', value: token)).thenAnswer((_) async {});

        final result = await authProvider.login(email, password);

        expect(result, equals(token));
        verify(mockStorage.write(key: 'jwt_token', value: token)).called(1);
      });

      test('throws an exception if login fails', () async {
        const email = 'john.doe@example.com';
        const password = 'wrongpassword';

        when(mockAuthService.login(email, password)).thenThrow(Exception());

        expect(() => authProvider.login(email, password), throwsException);
      });

      test('handles login with special characters in email', () async {
        const token = 'mock_jwt_token';
        const email = 'john.doe+test@example.com';
        const password = 'SecurePassword123!';

        when(mockAuthService.login(email, password)).thenAnswer((_) async => token);
        when(mockStorage.write(key: 'jwt_token', value: token)).thenAnswer((_) async {});

        final result = await authProvider.login(email, password);

        expect(result, equals(token));
        verify(mockStorage.write(key: 'jwt_token', value: token)).called(1);
      });
    });

    group('logout', () {
      test('logs out successfully', () async {
        const token = 'mock_jwt_token';

        when(mockStorage.read(key: 'jwt_token')).thenAnswer((_) async => token);
        when(mockAuthService.logout(token)).thenAnswer((_) async => true);
        when(mockStorage.delete(key: 'jwt_token')).thenAnswer((_) async {});

        await authProvider.logout();

        verify(mockAuthService.logout(token)).called(1);
        verify(mockStorage.delete(key: 'jwt_token')).called(1);
      });

      test('handles logout when token is missing', () async {
        when(mockStorage.read(key: 'jwt_token')).thenAnswer((_) async => null);

        await authProvider.logout();

        verifyNever(mockAuthService.logout(any));
        verifyNever(mockStorage.delete(key: 'jwt_token'));
      });

      test('handles logout when logout service fails', () async {
        const token = 'mock_jwt_token';

        when(mockStorage.read(key: 'jwt_token')).thenAnswer((_) async => token);
        when(mockAuthService.logout(token)).thenThrow(Exception());

        await authProvider.logout();

        verify(mockAuthService.logout(token)).called(1);
        verifyNever(mockStorage.delete(key: 'jwt_token'));
      });
    });

    group('deleteUserAccount', () {
      test('deletes user account successfully', () async {
        const token = 'mock_jwt_token';

        when(mockStorage.read(key: 'jwt_token')).thenAnswer((_) async => token);
        when(mockAuthService.deleteUserAccount(token)).thenAnswer((_) async {});
        when(mockStorage.delete(key: 'jwt_token')).thenAnswer((_) async {});

        await authProvider.deleteUserAccount();

        verify(mockAuthService.deleteUserAccount(token)).called(1);
        verify(mockStorage.delete(key: 'jwt_token')).called(1);
      });

      test('handles account deletion when token is missing', () async {
        when(mockStorage.read(key: 'jwt_token')).thenAnswer((_) async => null);

        await authProvider.deleteUserAccount();

        verifyNever(mockAuthService.deleteUserAccount(any));
        verifyNever(mockStorage.delete(key: 'jwt_token'));
      });

      test('handles account deletion when service fails', () async {
        const token = 'mock_jwt_token';

        when(mockStorage.read(key: 'jwt_token')).thenAnswer((_) async => token);
        when(mockAuthService.deleteUserAccount(token)).thenThrow(Exception());

        await authProvider.deleteUserAccount();

        verify(mockAuthService.deleteUserAccount(token)).called(1);
        verifyNever(mockStorage.delete(key: 'jwt_token'));
      });
    });

    group('getToken', () {
      test('returns token if valid', () async {
        const token = 'mock_jwt_token';

        when(mockStorage.read(key: 'jwt_token')).thenAnswer((_) async => token);

        final result = await authProvider.getToken();

        expect(result, equals(token));
      });

      test('returns null if token is missing', () async {
        when(mockStorage.read(key: 'jwt_token')).thenAnswer((_) async => null);

        final result = await authProvider.getToken();

        expect(result, isNull);
      });

      test('returns null if token is expired', () async {
        const token = 'mock_jwt_token';

        when(mockStorage.read(key: 'jwt_token')).thenAnswer((_) async => token);
        when(mockStorage.delete(key: 'jwt_token')).thenAnswer((_) async {});

        final result = await authProvider.getToken();

        expect(result, isNull);
        verify(mockStorage.delete(key: 'jwt_token')).called(1);
      });
    });

    group('deleteToken', () {
      test('deletes token successfully', () async {
        when(mockStorage.delete(key: 'jwt_token')).thenAnswer((_) async {});

        await authProvider.deleteToken();

        verify(mockStorage.delete(key: 'jwt_token')).called(1);
      });

      test('handles delete token when storage fails', () async {
        when(mockStorage.delete(key: 'jwt_token')).thenThrow(Exception());

        await authProvider.deleteToken();

        verify(mockStorage.delete(key: 'jwt_token')).called(1);
      });

      test('handles delete token when token is already null', () async {
        when(mockStorage.read(key: 'jwt_token')).thenAnswer((_) async => null);

        await authProvider.deleteToken();

        verifyNever(mockStorage.delete(key: 'jwt_token'));
      });
    });
  });
}
