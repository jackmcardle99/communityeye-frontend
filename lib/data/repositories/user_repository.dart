/*
File: user_repository.dart
Author: Jack McArdle

This file is part of CommunityEye.

Email: mcardle-j9@ulster.ac.uk
B-No: B00733578
*/

import 'package:communityeye_frontend/data/model/user.dart';
import 'package:communityeye_frontend/data/providers/auth_provider.dart';
import 'package:communityeye_frontend/data/services/auth_service.dart';
import 'package:communityeye_frontend/data/services/logger_service.dart';

class UserRepository {
  final AuthProvider _authProvider;
  final AuthService _authService;

  UserRepository(this._authProvider, this._authService);

  Future<User?> fetchUserProfile() async {
    try {
      String? token = await _authProvider.getToken();
      int? userId = _authProvider.userId;
      if (userId != null && token != null) {
        User? user = await _authService.fetchUser(userId, token);
        LoggerService.logger
            .i('Fetched user profile successfully for User ID: $userId.');
        return user;
      } else {
        LoggerService.logger.w('User ID is null. Cannot fetch user profile.');
        return null;
      }
    } catch (e) {
      LoggerService.logger.e('Error fetching user profile: $e');
      return null;
    }
  }

  Future<bool> updateUserProfile(Map<String, dynamic> updatedData) async {
    try {
      String? token = await _authProvider.getToken();
      int? userId = _authProvider.userId;
      if (userId != null && token != null) {
        return await _authService.updateUser(userId, updatedData, token);
      } else {
        LoggerService.logger.w('User ID is null or no authentication token found. Cannot update user profile.');
        return false;
      }
    } catch (e) {
      LoggerService.logger.e('Error updating user profile: $e');
      return false;
    }
  }
}
