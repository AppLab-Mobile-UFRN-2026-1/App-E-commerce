import 'package:shared_preferences/shared_preferences.dart';

class LoginSession {
  const LoginSession({
    required this.username,
    required this.password,
    required this.token,
  });

  final String username;
  final String password;
  final String token;
}

class SessionService {
  static const _usernameKey = 'login_username';
  static const _passwordKey = 'login_password';
  static const _tokenKey = 'login_token';

  Future<void> saveSession(LoginSession session) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_usernameKey, session.username);
    await prefs.setString(_passwordKey, session.password);
    await prefs.setString(_tokenKey, session.token);
  }

  Future<LoginSession?> getSession() async {
    final prefs = await SharedPreferences.getInstance();

    final username = prefs.getString(_usernameKey);
    final password = prefs.getString(_passwordKey);
    final token = prefs.getString(_tokenKey);

    if (username == null || password == null || token == null) {
      return null;
    }

    return LoginSession(
      username: username,
      password: password,
      token: token,
    );
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_usernameKey);
    await prefs.remove(_passwordKey);
    await prefs.remove(_tokenKey);
  }
}
