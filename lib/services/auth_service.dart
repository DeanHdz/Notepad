import '../db/database_helper.dart';
import '../models/user_model.dart';

class AuthService {
  //Metodo para registrar un nuevo usuario
  Future<bool> registerUser(
      String username, String email, String password) async {
    User user = User(username: username, email: email, password: password);
    int userId = await DatabaseHelper().createUser(user);
    return userId > 0;
  }

  //Metodo para iniciar sesion
  Future<User?> loginUser(String email, String password) async {
    return await DatabaseHelper().getUser(email, password);
  }
}
