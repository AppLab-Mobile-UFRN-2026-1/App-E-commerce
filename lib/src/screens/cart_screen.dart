import 'package:flutter/material.dart';

import '../models/cart_item.dart';
import '../services/cart_service.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({
    required this.cartService,
    super.key,
  });

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

      widget.cartService.clear();

      if (!mounted) {
        return;
      }

      final navigator = Navigator.of(context);
      final messenger = ScaffoldMessenger.of(context);

      messenger.showSnackBar(
        const SnackBar(
          content: Text('Compra confirmada com sucesso.'),
        ),
      );

      if (navigator.canPop()) {
        navigator.pop();
      }
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nao foi possivel confirmar a compra.'),
        ),
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
          appBar: AppBar(
            title: const Text('Meu Carrinho'),
          ),
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

              return _CartItemCard(
                item: item,
                isEnabled: !isCheckoutInProgress,
                onIncrement: () {
                  cartService.increment(item.product.id);
                },
                onDecrement: () {
                  cartService.decrement(item.product.id);
                },
                onRemove: () {
                  cartService.remove(item.product.id);
                },
              );
            },
          ),
        ),
        _CartTotalBar(
          cartService: cartService,
          isCheckoutInProgress: isCheckoutInProgress,
          onCheckout: onCheckout,
        ),
      ],
    );
  }
}

class _CartItemCard extends StatelessWidget {
  const _CartItemCard({
    required this.item,
    required this.isEnabled,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  final CartItem item;
  final bool isEnabled;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final canDecrement = isEnabled && item.quantity > 1;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 72,
              height: 72,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    item.product.imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) {
                      return Center(
                        child: Text(
                          item.product.icon,
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _formatPrice(item.product.price),
                    style: TextStyle(
                      color: colorScheme.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      IconButton.outlined(
                        tooltip: 'Diminuir quantidade',
                        onPressed: canDecrement ? onDecrement : null,
                        icon: const Icon(Icons.remove),
                      ),
                      SizedBox(
                        width: 36,
                        child: Text(
                          '${item.quantity}',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      IconButton.outlined(
                        tooltip: 'Aumentar quantidade',
                        onPressed: isEnabled ? onIncrement : null,
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  tooltip: 'Remover item',
                  onPressed: isEnabled ? onRemove : null,
                  icon: const Icon(Icons.delete_outline),
                ),
                const SizedBox(height: 20),
                Text(
                  _formatPrice(item.subtotal),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CartTotalBar extends StatelessWidget {
  const _CartTotalBar({
    required this.cartService,
    required this.isCheckoutInProgress,
    required this.onCheckout,
  });

  final CartService cartService;
  final bool isCheckoutInProgress;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      top: false,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          boxShadow: const [
            BoxShadow(
              blurRadius: 12,
              color: Color(0x22000000),
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${cartService.totalItems} itens',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatPrice(cartService.totalPrice),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: isCheckoutInProgress ? null : onCheckout,
                child: isCheckoutInProgress
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Confirmar compra'),
              ),
            ],
          ),
        ),
      ),
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
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
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

String _formatPrice(double price) {
  return 'R\$ ${price.toStringAsFixed(2)}';
}
