import 'package:applab_ecommerce/src/screens/splash_screen.dart';
import 'package:applab_ecommerce/src/theme/app_theme.dart';
import 'package:flutter/material.dart';

class AppLabEcommerceApp extends StatelessWidget {
  const AppLabEcommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
