import '../db/database_helper.dart';
import '../models/user_model.dart';

class AuthService {
  Future<bool> registerUser(
      String username, String email, String password) async {
    User user = User(username: username, email: email, password: password);
    int userId = await DatabaseHelper().createUser(user);
    return userId > 0;
  }

  Future<User?> loginUser(String email, String password) async {
    return await DatabaseHelper().getUser(email, password);
  }
}
