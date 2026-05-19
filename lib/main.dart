import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.dark(
          primary: Color(0xFF290349),
          onPrimary: Colors.white,
          secondary: Color(0xFF4A032F),
          onSecondary: Colors.white,
          surface: Color(0xFFF8F1FF),
          onSurface: Color(0xFF201429),
          error: Color(0xFFFF5A7A),
          onError: Colors.white,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.primary,
            body: Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'AppLab E-commerce',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      SizedBox(height: 32),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Usuário',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Senha',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary,
                              width: 2,
                            ),
                          ),
                        ),
                        obscureText: true,
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.secondary,
                          ),
                          child: Text(
                            'Login',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary,
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
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "Não tem uma conta? Cadastre-se",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
