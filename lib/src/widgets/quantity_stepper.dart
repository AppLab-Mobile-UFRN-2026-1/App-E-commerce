import 'package:flutter/material.dart';

class QuantityStepper extends StatelessWidget {
  const QuantityStepper({
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    this.isEnabled = true,
    this.minQuantity = 1,
    super.key,
  });

  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final bool isEnabled;
  final int minQuantity;

  @override
  Widget build(BuildContext context) {
    final canDecrement = isEnabled && quantity > minQuantity;

    return Row(
      children: [
        IconButton.outlined(
          tooltip: 'Diminuir quantidade',
          onPressed: canDecrement ? onDecrement : null,
          icon: const Icon(Icons.remove),
        ),
        SizedBox(
          width: 36,
          child: Text(
            '$quantity',
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
    );
  }
}
