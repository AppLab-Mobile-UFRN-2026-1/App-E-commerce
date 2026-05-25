import 'package:applab_ecommerce/src/screens/login_screen.dart';
import 'package:flutter/material.dart';

class AppLabEcommerceApp extends StatelessWidget {
  const AppLabEcommerceApp({super.key});

 @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(
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
      home: const LoginScreen(),
    );
  }
}
