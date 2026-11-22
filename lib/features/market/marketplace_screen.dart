/// Marketplace page (deck: "Marketplace - browse pre-loved items").
///
/// Buyers (citizens and businesses) browse verified sorted materials and
/// upcycled products, check out with Cash or Visa (simulated payment
/// gateway), and track orders.
library;

import 'package:flutter/material.dart';

import '../../core/app_state.dart';
import '../../core/models.dart';
import '../../core/theme.dart';

class MarketplaceScreen extends StatelessWidget {
  const MarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marketplace'),
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long_outlined),
            tooltip: 'My orders',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const OrdersScreen()),
            ),
          ),
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                key: const Key('cartButton'),
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const CartScreen()),
                ),
              ),
              if (state.cart.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: GColors.amber,
                    child: Text('${state.cart.length}',
                        style: const TextStyle(
                            fontSize: 10, color: Colors.black)),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final item in state.items) _ItemCard(item: item),
        ],
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  const _ItemCard({required this.item});

  final MarketplaceItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GCard(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ItemDetailScreen(item: item)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: categoryColor(item.category.label)
                    .withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(categoryIcon(item.category.label),
                  size: 32, color: categoryColor(item.category.label)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(item.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.w700)),
                      ),
                      if (item.isUpcycled)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: GColors.mint,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text('pre-loved',
                              style: TextStyle(
                                  fontSize: 10, color: GColors.deepGreen)),
                        ),
                    ],
                  ),
                  Text('${item.sellerName} - ${item.area}',
                      style: const TextStyle(
                          fontSize: 12, color: Colors.black54)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        'EGP ${item.priceEgp.toStringAsFixed(0)}/${item.unit}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            color: GColors.deepGreen),
                      ),
                      const Spacer(),
                      Flexible(
                        child: Text(
                          item.stockKg > 0
                              ? '${item.stockKg.toStringAsFixed(0)} ${item.unit} left'
                              : 'Out of stock',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.black54),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemDetailScreen extends StatefulWidget {
  const ItemDetailScreen({super.key, required this.item});

  final MarketplaceItem item;

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  double _qty = 1;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return Scaffold(
      appBar: AppBar(title: Text(item.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            height: 160,
            decoration: BoxDecoration(
              color: categoryColor(item.category.label)
                  .withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(categoryIcon(item.category.label),
                size: 72, color: categoryColor(item.category.label)),
          ),
          const SizedBox(height: 16),
          Text(item.title,
              style: Theme.of(context).textTheme.headlineSmall),
          Text('Sold by ${item.sellerName} - ${item.area}',
              style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 12),
          Text(item.description),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                  'EGP ${item.priceEgp.toStringAsFixed(0)} per ${item.unit}',
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: GColors.deepGreen)),
              const Spacer(),
              IconButton(
                onPressed: () =>
                    setState(() => _qty = (_qty - 1).clamp(1, 9999)),
                icon: const Icon(Icons.remove_circle_outline),
              ),
              Text('${_qty.toInt()}',
                  style: const TextStyle(fontWeight: FontWeight.w700)),
              IconButton(
                onPressed: () =>
                    setState(() => _qty = (_qty + 1).clamp(1, 9999)),
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            key: const Key('addToCartButton'),
            onPressed: item.stockKg > 0
                ? () {
                    AppScope.read(context).addToCart(item, _qty);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Added to cart')),
                    );
                  }
                : null,
            icon: const Icon(Icons.add_shopping_cart),
            label: const Text('Add to cart'),
          ),
        ],
      ),
    );
  }
}

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: state.cart.isEmpty
          ? const Center(child: Text('Your cart is empty.'))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                for (final line in state.cart)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: GCard(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(line.item.title,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700)),
                                Text(
                                    '${line.qty.toInt()} ${line.item.unit} x EGP ${line.item.priceEgp.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.black54)),
                              ],
                            ),
                          ),
                          Text('EGP ${line.total.toStringAsFixed(0)}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w800)),
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => AppScope.read(context)
                                .removeFromCart(line.item.id),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                GCard(
                  child: Row(
                    children: [
                      const Text('Total',
                          style:
                              TextStyle(fontWeight: FontWeight.w700)),
                      const Spacer(),
                      Text(
                        'EGP ${state.cartTotal.toStringAsFixed(2)}',
                        key: const Key('cartTotal'),
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: GColors.deepGreen),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  key: const Key('checkoutButton'),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => const CheckoutScreen()),
                  ),
                  child: const Text('Checkout'),
                ),
              ],
            ),
    );
  }
}

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  PaymentMethod _method = PaymentMethod.cash;
  final _card = TextEditingController();
  final _expiry = TextEditingController();
  final _cvv = TextEditingController();
  String? _error;

  Future<void> _pay() async {
    setState(() => _error = null);
    try {
      final order = await AppScope.read(context).checkout(
        method: _method,
        cardNumber: _card.text,
        expiry: _expiry.text,
        cvv: _cvv.text,
      );
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (_) => OrderSuccessScreen(orderId: order.id)),
      );
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GCard(
            child: Row(
              children: [
                const Text('Order total',
                    style: TextStyle(fontWeight: FontWeight.w700)),
                const Spacer(),
                Text('EGP ${state.cartTotal.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: GColors.deepGreen)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text('Payment method',
              style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          SegmentedButton<PaymentMethod>(
            segments: const [
              ButtonSegment(
                  value: PaymentMethod.cash,
                  label: Text('Cash'),
                  icon: Icon(Icons.payments_outlined)),
              ButtonSegment(
                  value: PaymentMethod.visa,
                  label: Text('Visa'),
                  icon: Icon(Icons.credit_card)),
            ],
            selected: {_method},
            onSelectionChanged: (s) =>
                setState(() => _method = s.first),
          ),
          if (_method == PaymentMethod.visa) ...[
            const SizedBox(height: 16),
            TextField(
              key: const Key('cardNumberField'),
              controller: _card,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Card number',
                hintText: '4242 4242 4242 4242',
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _expiry,
                    decoration: const InputDecoration(
                        labelText: 'Expiry (MM/YY)', hintText: '12/27'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _cvv,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    decoration:
                        const InputDecoration(labelText: 'CVV'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Demo gateway: any 16-digit card succeeds; a card ending in '
              '0000 is declined ("Try Another Card").',
              style: TextStyle(fontSize: 11, color: Colors.black54),
            ),
          ],
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(_error!, style: const TextStyle(color: Colors.red)),
          ],
          const SizedBox(height: 24),
          FilledButton(
            key: const Key('payButton'),
            onPressed: state.busy ? null : _pay,
            child: state.busy
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : Text(_method == PaymentMethod.cash
                    ? 'Place order'
                    : 'Pay now'),
          ),
        ],
      ),
    );
  }
}

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle,
                  size: 80, color: GColors.leaf),
              const SizedBox(height: 16),
              Text('Order placed!',
                  style: Theme.of(context).textTheme.headlineSmall),
              Text('Order $orderId is being prepared.',
                  style: const TextStyle(color: Colors.black54)),
              const SizedBox(height: 24),
              FilledButton(
                key: const Key('trackOrderButton'),
                onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (_) => const OrdersScreen()),
                ),
                child: const Text('Track my orders'),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.of(context).popUntil((r) => r.isFirst),
                child: const Text('Back to Marketplace'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('My orders')),
      body: state.myOrders.isEmpty
          ? const Center(child: Text('No orders yet.'))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                for (final order in state.myOrders)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(order.id,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w800)),
                              const Spacer(),
                              Text(
                                  'EGP ${order.totalEgp.toStringAsFixed(2)}'),
                            ],
                          ),
                          Text(
                            '${order.lines.length} item(s) - ${order.paymentMethod.label}',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.black54),
                          ),
                          const SizedBox(height: 12),
                          _OrderTimeline(order: order),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}

class _OrderTimeline extends StatelessWidget {
  const _OrderTimeline({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    const steps = [
      OrderStatus.pending,
      OrderStatus.preparing,
      OrderStatus.outForDelivery,
      OrderStatus.delivered,
    ];
    final currentIndex = steps.indexOf(order.status);
    return Row(
      children: [
        for (var i = 0; i < steps.length; i++) ...[
          if (i > 0)
            Expanded(
              child: Container(
                height: 2,
                color: i <= currentIndex
                    ? GColors.leaf
                    : Colors.black12,
              ),
            ),
          Column(
            children: [
              Icon(
                i <= currentIndex
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                size: 18,
                color:
                    i <= currentIndex ? GColors.leaf : Colors.black26,
              ),
              Text(steps[i].label,
                  style: const TextStyle(fontSize: 9)),
            ],
          ),
        ],
      ],
    );
  }
}
