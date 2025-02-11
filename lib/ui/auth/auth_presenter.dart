import 'package:communityeye_frontend/data/model/user.dart';
import 'package:communityeye_frontend/ui/auth/auth_viewmodel.dart';

class AuthPresenter {
  final AuthViewModel viewModel;

  AuthPresenter(this.viewModel);

  Future<String?> registerUser(User user) {
    return viewModel.register(user);
  }

  Future<String?> loginUser(String email, String password) {
    return viewModel.login(email, password);
  }
}
