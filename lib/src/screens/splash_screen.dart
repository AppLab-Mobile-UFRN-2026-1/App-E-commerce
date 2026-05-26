import 'package:applab_ecommerce/src/screens/login_screen.dart';
import 'package:applab_ecommerce/src/screens/products_screen.dart';
import 'package:applab_ecommerce/src/services/auth_service.dart';
import 'package:applab_ecommerce/src/services/session_service.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _authService = AuthService();
  final _sessionService = SessionService();

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  @override
  void dispose() {
    _authService.dispose();
    super.dispose();
  }

  Future<void> _checkSession() async {
    final session = await _sessionService.getSession();

    if (!mounted) {
      return;
    }

    if (session == null) {
      _goToLogin();
      return;
    }

    try {
      final token = await _authService.login(
        username: session.username,
        password: session.password,
      );

      await _sessionService.saveSession(
        LoginSession(
          username: session.username,
          password: session.password,
          token: token,
        ),
      );

      if (!mounted) {
        return;
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => ProductsScreen(username: session.username),
        ),
      );
    } catch (_) {
      await _sessionService.clearSession();

      if (!mounted) {
        return;
      }

      _goToLogin();
    }
  }

  void _goToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
