class AuthService {
  static Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // simulate API

    // Dummy credentials
    if (email == "student@gmail.com" && password == "student123@") {
      return true;
    }

    return false;
  }
}