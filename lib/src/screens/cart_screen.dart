import 'package:flutter/material.dart';

import '../services/cart_service.dart';
import '../widgets/cart_item_tile.dart';
import '../widgets/cart_summary_bar.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({required this.cartService, super.key});

  final CartService cartService;

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isCheckingOut = false;

  Future<void> _confirmPurchase() async {
    if (_isCheckingOut || widget.cartService.isEmpty) {
      return;
    }

    setState(() {
      _isCheckingOut = true;
    });

    try {
      await Future<void>.delayed(const Duration(seconds: 1));

      await widget.cartService.clear();

      if (!mounted) {
        return;
      }

      final navigator = Navigator.of(context);
      final messenger = ScaffoldMessenger.of(context);

      messenger.showSnackBar(
        const SnackBar(content: Text('Compra confirmada com sucesso.')),
      );

      if (navigator.canPop()) {
        navigator.pop();
      }
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nao foi possivel confirmar a compra.')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isCheckingOut = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.cartService,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Meu Carrinho')),
          body: widget.cartService.isEmpty
              ? const _EmptyCartView()
              : _CartContent(
                  cartService: widget.cartService,
                  isCheckoutInProgress: _isCheckingOut,
                  onCheckout: _confirmPurchase,
                ),
        );
      },
    );
  }
}

class _CartContent extends StatelessWidget {
  const _CartContent({
    required this.cartService,
    required this.isCheckoutInProgress,
    required this.onCheckout,
  });

  final CartService cartService;
  final bool isCheckoutInProgress;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: cartService.items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = cartService.items[index];

              return CartItemTile(
                item: item,
                isEnabled: !isCheckoutInProgress,
                onIncrement: () async {
                  await cartService.increment(item.product.id);
                },
                onDecrement: () async {
                  await cartService.decrement(item.product.id);
                },
                onRemove: () async {
                  await cartService.remove(item.product.id);
                },
              );
            },
          ),
        ),
        CartSummaryBar(
          cartService: cartService,
          isCheckoutInProgress: isCheckoutInProgress,
          onCheckout: onCheckout,
        ),
      ],
    );
  }
}

class _EmptyCartView extends StatelessWidget {
  const _EmptyCartView();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 56,
              color: colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Seu carrinho está vazio',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Adicione produtos pela vitrine para continuar.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
