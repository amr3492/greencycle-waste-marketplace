/// Admin page (deck: "Admin pricing management" and catalog editing).
library;

import 'package:flutter/material.dart';

import '../../core/app_state.dart';
import '../../core/models.dart';
import '../../core/theme.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Admin console')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Catalog pricing',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          for (final item in state.items)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GCard(
                child: Row(
                  children: [
                    Icon(categoryIcon(item.category.label),
                        color: categoryColor(item.category.label)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(item.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700)),
                    ),
                    Text(
                        'EGP ${item.priceEgp.toStringAsFixed(0)}/${item.unit}'),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () =>
                          _editPrice(context, state, item),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 16),
          Text('Smart bin fleet',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          for (final bin in state.bins)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GCard(
                child: Row(
                  children: [
                    const Icon(Icons.delete_outline,
                        color: GColors.seed),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(bin.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700)),
                          Text(bin.qrCode,
                              style: const TextStyle(
                                  fontSize: 11,
                                  fontFamily: 'monospace',
                                  color: Colors.black54)),
                        ],
                      ),
                    ),
                    Text(
                        '${(bin.averageFill * 100).round()}% full - ${bin.status.name}'),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _editPrice(
      BuildContext context, AppState state, MarketplaceItem item) {
    final controller =
        TextEditingController(text: item.priceEgp.toStringAsFixed(0));
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Edit price - ${item.title}'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration:
              InputDecoration(labelText: 'EGP per ${item.unit}'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final price = double.tryParse(controller.text);
              if (price != null && price > 0) {
                state.adminSetPrice(item.id, price);
                Navigator.of(ctx).pop();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
