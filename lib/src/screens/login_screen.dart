import 'package:applab_ecommerce/src/screens/products_screen.dart';
import 'package:applab_ecommerce/src/services/auth_service.dart';
import 'package:applab_ecommerce/src/services/session_service.dart';
import 'package:applab_ecommerce/src/widgets/app_text_field.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  final _sessionService = SessionService();

  bool _isLoading = false;

  @override
  void dispose() {
    _authService.dispose();
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _requiredField(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Campo obrigatório';
    }

    return null;
  }

  Future<void> _submit() async {
    final isValidForm = _formKey.currentState?.validate() ?? false;

    if (!isValidForm) {
      return;
    }

    final user = _userController.text.trim();
    final password = _passwordController.text;

    setState(() {
      _isLoading = true;
    });

    try {
      final token = await _authService.login(
        username: user,
        password: password,
      );

      await _sessionService.saveSession(
        LoginSession(username: user, password: password, token: token),
      );

      if (!mounted) {
        return;
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => ProductsScreen(username: user)),
      );
    } on AuthException catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível fazer login')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  child: SizedBox(
                    width: 300,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'AppLab E-commerce',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          SizedBox(height: 32),
                          AppTextField(
                            controller: _userController,
                            title: 'Usuário',
                            hintText: 'Digite seu usuário',
                            icon: Icons.person_outline,
                            validator: _requiredField,
                          ),
                          SizedBox(height: 16),
                          AppTextField(
                            controller: _passwordController,
                            title: 'Senha',
                            hintText: 'Digite sua senha',
                            icon: Icons.lock_outline,
                            validator: _requiredField,
                            obscureText: true,
                          ),
                          SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.secondary,
                              ),
                              child: _isLoading
                                  ? SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSecondary,
                                      ),
                                    )
                                  : Text(
                                      'Login',
                                      style: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSecondary,
                                        fontSize: 16,
                                      ),
                                    ),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Esqueceu a senha?',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              "Não tem uma conta? Cadastre-se",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
