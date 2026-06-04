import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({required this.product, required this.onBuy, super.key});

  final Product product;
  final VoidCallback onBuy;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasRating = product.ratingRate != null || product.ratingCount != null;

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
            if (hasRating) ...[
              const SizedBox(height: 8),
              _ProductRating(
                ratingRate: product.ratingRate,
                ratingCount: product.ratingCount,
              ),
            ],
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
                onPressed: onBuy,
                child: const Text('Comprar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductRating extends StatelessWidget {
  const _ProductRating({required this.ratingRate, required this.ratingCount});

  final double? ratingRate;
  final int? ratingCount;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final rateLabel = ratingRate?.toStringAsFixed(1);
    final countLabel = ratingCount == null ? null : '($ratingCount)';

    return Row(
      children: [
        Icon(Icons.star_rounded, size: 18, color: Colors.amber.shade700),
        const SizedBox(width: 4),
        Text(
          [?rateLabel, ?countLabel].join(' '),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
