import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({required this.product, super.key});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: 150,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) {
                      return Center(
                        child: CircleAvatar(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                          radius: 28,
                          child: Text(product.icon),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              product.category,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Text(
                product.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              product.formattedPrice,
              style: TextStyle(
                color: colorScheme.secondary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Comprar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
