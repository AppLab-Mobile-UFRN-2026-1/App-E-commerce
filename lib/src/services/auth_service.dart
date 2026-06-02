import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}

class AuthService {
  AuthService({http.Client? client}) : _client = client ?? http.Client();

  static final Uri _loginUrl = Uri.parse(
    'https://fakestoreapi.com/auth/login',
  );

  final http.Client _client;

  Future<String> login({
    required String username,
    required String password,
  }) async {
    final response = await _client.post(
      _loginUrl,
      headers: const {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw const AuthException('Credenciais inválidas');
    }

    final data = jsonDecode(response.body);

    if (data is! Map<String, dynamic> || data['token'] is! String) {
      throw const AuthException('Resposta de autenticação inválida');
    }

    return data['token'] as String;
  }

  void dispose() {
    _client.close();
  }
}
