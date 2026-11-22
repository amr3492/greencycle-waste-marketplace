/// Eco-points wallet: balance, history, redemption for vouchers or cash
/// (deck: eco-points redemption workflows, Sponsor offers).
library;

import 'package:flutter/material.dart';

import '../../core/app_state.dart';
import '../../core/models.dart';
import '../../core/theme.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Wallet')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [GColors.seed, GColors.deepGreen],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Eco-points',
                    style: TextStyle(color: Colors.white70)),
                Text('${state.points}',
                    key: const Key('walletPoints'),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.w800)),
                Text(
                    'Cash: EGP ${state.walletEgp.toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: FilledButton.tonalIcon(
                  key: const Key('cashOutButton'),
                  onPressed: state.points >= 100
                      ? () => _showCashOut(context, state)
                      : null,
                  icon: const Icon(Icons.payments_outlined),
                  label: const Text('Convert to cash'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton.tonalIcon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => const RewardsScreen()),
                  ),
                  icon: const Icon(Icons.card_giftcard),
                  label: const Text('Rewards'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text('History', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          if (state.txns.isEmpty)
            const Text('No transactions yet.',
                style: TextStyle(color: Colors.black54)),
          for (final txn in state.txns) _TxnTile(txn: txn),
        ],
      ),
    );
  }

  void _showCashOut(BuildContext context, AppState state) {
    final controller = TextEditingController(text: '${state.points}');
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Convert points to cash'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('100 eco-points = EGP 10.00'),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(labelText: 'Points to convert'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final pts = int.tryParse(controller.text) ?? 0;
              try {
                state.cashOut(pts);
                Navigator.of(ctx).pop();
              } catch (_) {
                // invalid amount: keep dialog open
              }
            },
            child: const Text('Convert'),
          ),
        ],
      ),
    );
  }
}

class _TxnTile extends StatelessWidget {
  const _TxnTile({required this.txn});

  final WalletTransaction txn;

  @override
  Widget build(BuildContext context) {
    final icon = switch (txn.kind) {
      TxnKind.deposit => Icons.recycling,
      TxnKind.purchase => Icons.shopping_bag_outlined,
      TxnKind.redemption => Icons.card_giftcard,
      TxnKind.cashOut => Icons.payments_outlined,
      TxnKind.bonus => Icons.stars_outlined,
    };
    final delta = StringBuffer();
    if (txn.pointsDelta != 0) {
      delta.write('${txn.pointsDelta > 0 ? '+' : ''}${txn.pointsDelta} pts');
    }
    if (txn.egpDelta != 0) {
      if (delta.isNotEmpty) delta.write('  ');
      delta.write(
          '${txn.egpDelta > 0 ? '+' : ''}EGP ${txn.egpDelta.toStringAsFixed(2)}');
    }
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: GColors.mint,
        child: Icon(icon, color: GColors.seed, size: 20),
      ),
      title: Text(txn.label, style: const TextStyle(fontSize: 14)),
      subtitle: Text(
        '${txn.at.hour.toString().padLeft(2, '0')}:${txn.at.minute.toString().padLeft(2, '0')}',
        style: const TextStyle(fontSize: 11),
      ),
      trailing: Text(delta.toString(),
          style: TextStyle(
              fontWeight: FontWeight.w700,
              color: txn.pointsDelta >= 0 && txn.egpDelta >= 0
                  ? GColors.deepGreen
                  : Colors.redAccent)),
    );
  }
}

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Rewards')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Sponsor vouchers',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          for (final v in state.vouchers)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GCard(
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: GColors.mint,
                      child: Icon(Icons.card_giftcard,
                          color: GColors.seed),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(v.title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700)),
                          Text('by ${v.sponsor}',
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54)),
                        ],
                      ),
                    ),
                    FilledButton.tonal(
                      onPressed: state.points >= v.pointsCost
                          ? () async {
                              final r =
                                  await AppScope.read(context)
                                      .redeemVoucher(v);
                              if (!context.mounted) return;
                              showDialog<void>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Voucher ready'),
                                  content: Text(
                                      'Show this code at ${v.sponsor}:\n\n${r.code}'),
                                  actions: [
                                    FilledButton(
                                      onPressed: () =>
                                          Navigator.of(ctx).pop(),
                                      child: const Text('Done'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          : null,
                      child: Text('${v.pointsCost} pts'),
                    ),
                  ],
                ),
              ),
            ),
          if (state.redemptions.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text('My vouchers',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            for (final r in state.redemptions)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.confirmation_num_outlined,
                    color: GColors.seed),
                title: Text(r.voucher.title,
                    style: const TextStyle(fontSize: 14)),
                subtitle: Text(r.code,
                    style: const TextStyle(
                        fontFamily: 'monospace', fontSize: 12)),
              ),
          ],
        ],
      ),
    );
  }
}
