import 'package:communityeye_frontend/data/model/user.dart';
import 'package:communityeye_frontend/data/providers/auth_provider.dart';
import 'package:communityeye_frontend/data/services/logger_service.dart';

class UserRepository {
  final AuthProvider _authProvider;

  UserRepository(this._authProvider);

  Future<User?> fetchUserProfile() async {
    try {
      int? userId = _authProvider.userId;
      if (userId != null) {
        User? user = await _authProvider.fetchUser(userId);
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
}
