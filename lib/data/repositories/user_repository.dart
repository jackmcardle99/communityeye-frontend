import 'package:communityeye_frontend/data/model/user.dart';
import 'package:communityeye_frontend/data/providers/auth_provider.dart';

class UserRepository {
  final AuthProvider _authProvider;

  UserRepository(this._authProvider);

  Future<User?> fetchUserProfile() async {
    int? userId = _authProvider.getCurrentUserId();
    if (userId != null) {
      return await _authProvider.fetchUser(userId);
    }
    return null;
  }
}
