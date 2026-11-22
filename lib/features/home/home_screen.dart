/// Home page (deck "Demo Mobile Application": Home).
///
/// Eco-points overview, total recycled weight, and nearby smart bins.
library;

import 'package:flutter/material.dart';

import '../../core/app_state.dart';
import '../../core/models.dart';
import '../../core/theme.dart';
import '../recycle/recycle_flow.dart';
import '../wallet/wallet_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final user = state.currentUser!;
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hello, ${user.name.split(' ').first}',
                style: const TextStyle(fontSize: 18)),
            Text(user.role.label,
                style:
                    const TextStyle(fontSize: 12, color: Colors.white70)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: state.refresh,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: state.refresh,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _PointsCard(points: state.points, egp: state.walletEgp),
            const SizedBox(height: 16),
            _StatsRow(
              recycledKg: state.totalRecycledKg,
              co2Kg: state.co2SavedKg,
              deposits: state.records.length,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Text('Nearby smart bins',
                    style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                const Icon(Icons.location_on_outlined,
                    size: 18, color: GColors.seed),
              ],
            ),
            const SizedBox(height: 8),
            for (final bin in state.bins) _BinTile(bin: bin),
          ],
        ),
      ),
    );
  }
}

class _PointsCard extends StatelessWidget {
  const _PointsCard({required this.points, required this.egp});

  final int points;
  final double egp;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const WalletScreen()),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [GColors.seed, GColors.deepGreen],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.eco_outlined, color: Colors.white70),
                SizedBox(width: 8),
                Text('Eco-points wallet',
                    style: TextStyle(color: Colors.white70)),
                Spacer(),
                Icon(Icons.chevron_right, color: Colors.white70),
              ],
            ),
            const SizedBox(height: 12),
            Text('$points pts',
                key: const Key('homePoints'),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w800)),
            Text('Cash balance: EGP ${egp.toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({
    required this.recycledKg,
    required this.co2Kg,
    required this.deposits,
  });

  final double recycledKg;
  final double co2Kg;
  final int deposits;

  @override
  Widget build(BuildContext context) {
    Widget stat(String value, String label, IconData icon) => Expanded(
          child: GCard(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Column(
              children: [
                Icon(icon, color: GColors.seed),
                const SizedBox(height: 6),
                Text(value,
                    style: const TextStyle(
                        fontWeight: FontWeight.w800, fontSize: 16)),
                Text(label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 11, color: Colors.black54)),
              ],
            ),
          ),
        );
    return Row(
      children: [
        stat('${recycledKg.toStringAsFixed(2)} kg', 'Total recycled',
            Icons.recycling),
        const SizedBox(width: 10),
        stat('${co2Kg.toStringAsFixed(2)} kg', 'CO2 saved',
            Icons.cloud_outlined),
        const SizedBox(width: 10),
        stat('$deposits', 'Deposits', Icons.inventory_2_outlined),
      ],
    );
  }
}

class _BinTile extends StatelessWidget {
  const _BinTile({required this.bin});

  final SmartBin bin;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (bin.status) {
      BinStatus.online => ('Online', GColors.leaf),
      BinStatus.full => ('Full - needs collection', GColors.amber),
      BinStatus.maintenance => ('Under maintenance', Colors.redAccent),
    };
    final canUse = bin.status == BinStatus.online;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GCard(
        onTap: canUse
            ? () => Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (_) => RecycleFlowScreen(bin: bin)),
                )
            : null,
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: GColors.mint,
              child: const Icon(Icons.delete_outline,
                  color: GColors.seed),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(bin.name,
                      style:
                          const TextStyle(fontWeight: FontWeight.w700)),
                  Text('${bin.area} - ${bin.distanceKm} km away',
                      style: const TextStyle(
                          fontSize: 12, color: Colors.black54)),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: bin.averageFill,
                      minHeight: 6,
                      backgroundColor: Colors.black12,
                      color: bin.averageFill > 0.85
                          ? Colors.redAccent
                          : GColors.leaf,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('${(bin.averageFill * 100).round()}% full',
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w700)),
                Text(label,
                    style: TextStyle(fontSize: 11, color: color)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
