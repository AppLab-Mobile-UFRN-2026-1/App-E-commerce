import 'package:flutter/material.dart';

import '../models/product.dart';
import '../screens/login_screen.dart';
import '../services/product_service.dart';
import '../services/session_service.dart';
import '../widgets/product_card.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final _productService = ProductService();
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  void dispose() {
    _productService.dispose();
    super.dispose();
  }

  void _loadProducts() {
    _productsFuture = _productService.fetchProducts();
  }

  Future<void> _retryLoadProducts() async {
    setState(_loadProducts);
    await _productsFuture;
  }

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
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const _ProductsStatusView(
              icon: Icons.shopping_bag_outlined,
              title: 'Carregando produtos',
              message: 'Estamos buscando os itens disponiveis para voce.',
              child: Padding(
                padding: EdgeInsets.only(top: 16),
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (snapshot.hasError) {
            final errorMessage = switch (snapshot.error) {
              final ProductServiceException error => error.message,
              _ => 'Não foi possível carregar os produtos.',
            };

            return _ProductsStatusView(
              icon: Icons.wifi_off_rounded,
              title: 'Falha ao carregar a vitrine',
              message: errorMessage,
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(_loadProducts);
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Tentar novamente'),
                ),
              ),
            );
          }

          final products = snapshot.data ?? const <Product>[];

          if (products.isEmpty) {
            return _ProductsStatusView(
              icon: Icons.inventory_2_outlined,
              title: 'Nenhum produto encontrado',
              message:
                  'A lista esta vazia no momento. Tente atualizar em instantes.',
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: OutlinedButton.icon(
                  onPressed: () {
                    setState(_loadProducts);
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Atualizar lista'),
                ),
              ),
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final crossAxisCount = width >= 900
                  ? 4
                  : width >= 640
                  ? 3
                  : 2;

              return RefreshIndicator(
                onRefresh: _retryLoadProducts,
                child: GridView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  itemCount: products.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: width < 420 ? 0.58 : 0.68,
                  ),
                  itemBuilder: (context, index) {
                    return ProductCard(product: products[index]);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _ProductsStatusView extends StatelessWidget {
  const _ProductsStatusView({
    required this.icon,
    required this.title,
    required this.message,
    this.child,
  });

  final IconData icon;
  final String title;
  final String message;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 52, color: colorScheme.primary),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              child ?? const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
