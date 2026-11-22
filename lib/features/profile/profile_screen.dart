/// Profile page (deck: "Profile - eco-points, recycling stats, recent
/// activity, and available rewards").
library;

import 'package:flutter/material.dart';

import '../../core/app_state.dart';
import '../../core/models.dart';
import '../../core/theme.dart';
import '../wallet/wallet_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final user = state.currentUser!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign out',
            onPressed: () => AppScope.read(context).signOut(),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GCard(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: GColors.mint,
                  child: Text(
                    user.name.isEmpty
                        ? '?'
                        : user.name[0].toUpperCase(),
                    style: const TextStyle(
                        fontSize: 24,
                        color: GColors.deepGreen,
                        fontWeight: FontWeight.w800),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.name,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800)),
                      Text(user.email,
                          style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54)),
                      const SizedBox(height: 4),
                      Chip(
                        label: Text(user.role.label),
                        visualDensity: VisualDensity.compact,
                        backgroundColor: GColors.mint,
                        side: BorderSide.none,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          GCard(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const WalletScreen()),
            ),
            child: Row(
              children: [
                const Icon(Icons.eco_outlined, color: GColors.seed),
                const SizedBox(width: 12),
                Expanded(
                  child: Text('${state.points} eco-points',
                      key: const Key('profilePoints'),
                      style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16)),
                ),
                Text(
                    'EGP ${state.walletEgp.toStringAsFixed(2)} cash',
                    style:
                        const TextStyle(color: Colors.black54)),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
          const SizedBox(height: 16),
          GCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Recycling stats',
                    style:
                        Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 12),
                _StatsBars(counts: state.depositCounts),
                const SizedBox(height: 8),
                Text(
                  'Total: ${state.totalRecycledKg.toStringAsFixed(2)} kg recycled, '
                  '${state.co2SavedKg.toStringAsFixed(2)} kg CO2 saved',
                  style: const TextStyle(
                      fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          GCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Recent activity',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall),
                    const Spacer(),
                    TextButton(
                      onPressed: () =>
                          Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => const RewardsScreen()),
                      ),
                      child: const Text('Rewards'),
                    ),
                  ],
                ),
                if (state.txns.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text('Nothing yet - recycle something!',
                        style:
                            TextStyle(color: Colors.black54)),
                  )
                else
                  for (final txn in state.txns.take(5))
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          const Icon(Icons.circle,
                              size: 8, color: GColors.leaf),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(txn.label,
                                style: const TextStyle(
                                    fontSize: 13)),
                          ),
                          Text(
                            txn.pointsDelta != 0
                                ? '${txn.pointsDelta > 0 ? '+' : ''}${txn.pointsDelta} pts'
                                : '${txn.egpDelta > 0 ? '+' : ''}EGP ${txn.egpDelta.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: txn.pointsDelta >= 0
                                  ? GColors.deepGreen
                                  : Colors.redAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsBars extends StatelessWidget {
  const _StatsBars({required this.counts});

  final Map<WasteCategory, int> counts;

  @override
  Widget build(BuildContext context) {
    final max = counts.values.fold(0, (a, b) => a > b ? a : b);
    return Column(
      children: [
        for (final c in WasteCategory.values)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                SizedBox(
                  width: 64,
                  child: Text(c.label,
                      style: const TextStyle(fontSize: 12)),
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: max == 0 ? 0 : counts[c]! / max,
                      minHeight: 10,
                      backgroundColor: Colors.black12,
                      color: categoryColor(c.label),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text('${counts[c]}',
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700)),
              ],
            ),
          ),
      ],
    );
  }
}
