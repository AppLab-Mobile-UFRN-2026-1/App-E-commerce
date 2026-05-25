import 'package:flutter/material.dart';

import '../data/sample_products.dart';
import '../screens/login_screen.dart';
import '../services/session_service.dart';
import '../widgets/product_card.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AppLab Ecommerce'),
        actions: [
          IconButton(
            tooltip: 'Sair',
            onPressed: () async {
              await SessionService().clearSession();

              if (!context.mounted) {
                return;
              }

              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final crossAxisCount = width >= 900
              ? 4
              : width >= 640
                  ? 3
                  : 2;

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: sampleProducts.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount, // quantidade de colunas
              crossAxisSpacing: 16, // espaco horizontal entre os cards
              mainAxisSpacing: 16, // espaco vertical entre os cards
              childAspectRatio: width < 420 ? 0.72 : 0.82, // largura / altura
            ),
            itemBuilder: (context, index) {
              return ProductCard(product: sampleProducts[index]);
            },
          );
        },
      ),
    );
  }
}
