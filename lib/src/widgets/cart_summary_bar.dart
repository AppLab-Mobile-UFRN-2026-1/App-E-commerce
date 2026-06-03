import 'package:flutter/material.dart';

import '../services/cart_service.dart';

class CartSummaryBar extends StatelessWidget {
  const CartSummaryBar({
    required this.cartService,
    required this.onCheckout,
    this.isCheckoutInProgress = false,
    super.key,
  });

  final CartService cartService;
  final VoidCallback onCheckout;
  final bool isCheckoutInProgress;

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

String _formatPrice(double price) {
  return 'R\$ ${price.toStringAsFixed(2)}';
}
