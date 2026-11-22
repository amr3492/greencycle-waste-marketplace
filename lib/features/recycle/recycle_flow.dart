/// Recycle page + smart-bin simulation (deck: "Recycle" page and the AI
/// classification & sorting simulation slide).
///
/// Full simulated loop: pick waste type -> scan bin QR (simulated
/// viewfinder) -> lid opens -> camera capture -> AI classification with
/// confidence score -> servo flap countdown -> deposit -> instant
/// eco-points. Mirrors the deck's IoT Smart Bin sequence diagram; the
/// physical ESP32/servo hardware is out of scope for the app and is
/// simulated here exactly as the deck itself simulates it.
library;

import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/app_state.dart';
import '../../core/models.dart';
import '../../core/theme.dart';

enum _Step { chooseBin, chooseType, scanning, classifying, sorting, done }

class RecycleFlowScreen extends StatefulWidget {
  const RecycleFlowScreen({super.key, this.bin});

  /// Pre-selected bin when arriving from a bin tile; null from the tab.
  final SmartBin? bin;

  @override
  State<RecycleFlowScreen> createState() => _RecycleFlowScreenState();
}

class _RecycleFlowScreenState extends State<RecycleFlowScreen> {
  _Step _step = _Step.chooseBin;
  SmartBin? _bin;
  WasteCategory? _type;
  WasteRecord? _record;
  String? _scanError;
  int _countdown = 3;
  String _statusLine = '';
  Timer? _timer;
  final _qrController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bin = widget.bin;
    if (_bin != null) _step = _Step.chooseType;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _qrController.dispose();
    super.dispose();
  }

  void _pickBin(SmartBin bin) => setState(() {
        _bin = bin;
        _step = _Step.chooseType;
      });

  void _pickType(WasteCategory type) => setState(() {
        _type = type;
        _step = _Step.scanning;
        _scanError = null;
      });

  void _startQrSim() {
    setState(() {
      _statusLine = 'Aiming camera at bin QR sticker...';
    });
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      setState(() => _statusLine = 'QR detected: ${_bin!.qrCode}');
      _timer = Timer(const Duration(milliseconds: 900), _beginClassification);
    });
  }

  void _submitManualCode() {
    final backend = AppScope.read(context).backend;
    final found = backend.findBinByQr(_qrController.text);
    if (found == null) {
      setState(() => _scanError =
          'No smart bin matches that code. Try ${_bin!.qrCode} for the demo.');
      return;
    }
    setState(() {
      _scanError = null;
      _statusLine = 'QR verified: ${found.qrCode}';
    });
    _timer = Timer(const Duration(milliseconds: 700), _beginClassification);
  }

  void _beginClassification() {
    if (!mounted) return;
    setState(() {
      _step = _Step.classifying;
      _statusLine = 'Lid opening... camera capturing item...';
    });
    _timer = Timer(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      setState(() => _statusLine = 'AI model analysing material...');
      _timer = Timer(const Duration(milliseconds: 1500), _beginSorting);
    });
  }

  Future<void> _beginSorting() async {
    if (!mounted) return;
    final state = AppScope.read(context);
    final record =
        await state.deposit(binId: _bin!.id, category: _type!);
    if (!mounted) return;
    setState(() {
      _record = record;
      _step = _Step.sorting;
      _countdown = 3;
      _statusLine = 'Servo flap moving to ${record.category.label} slot';
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (_countdown <= 1) {
        t.cancel();
        setState(() {
          _step = _Step.done;
          _statusLine = 'Item deposited. Points added to wallet.';
        });
      } else {
        setState(() => _countdown--);
      }
    });
  }

  void _reset() => setState(() {
        _step = _bin == null ? _Step.chooseBin : _Step.chooseType;
        if (widget.bin == null) _bin = null;
        _type = null;
        _record = null;
        _countdown = 3;
        _statusLine = '';
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recycle')),
      body: switch (_step) {
        _Step.chooseBin => _BinPicker(onPick: _pickBin),
        _Step.chooseType => _TypePicker(bin: _bin!, onPick: _pickType),
        _Step.scanning => _ScannerPanel(
            bin: _bin!,
            statusLine: _statusLine,
            error: _scanError,
            qrController: _qrController,
            onSimulateScan: _startQrSim,
            onManualSubmit: _submitManualCode,
          ),
        _Step.classifying => _ClassifyPanel(statusLine: _statusLine),
        _Step.sorting => _SortingPanel(
            record: _record!,
            countdown: _countdown,
            statusLine: _statusLine,
          ),
        _Step.done => _DonePanel(
            record: _record!,
            onAgain: _reset,
          ),
      },
    );
  }
}

class _BinPicker extends StatelessWidget {
  const _BinPicker({required this.onPick});

  final ValueChanged<SmartBin> onPick;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final usable = state.bins
        .where((b) => b.status == BinStatus.online)
        .toList();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('1. Choose a smart bin',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 4),
        const Text('Only online bins can accept deposits.',
            style: TextStyle(fontSize: 12, color: Colors.black54)),
        const SizedBox(height: 12),
        for (final bin in usable)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: GCard(
              onTap: () => onPick(bin),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: GColors.mint,
                    child: Icon(Icons.delete_outline,
                        color: GColors.seed),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(bin.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.w700)),
                        Text(
                            '${bin.area} - ${bin.distanceKm} km - ${(bin.averageFill * 100).round()}% full',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.black54)),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _TypePicker extends StatelessWidget {
  const _TypePicker({required this.bin, required this.onPick});

  final SmartBin bin;
  final ValueChanged<WasteCategory> onPick;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('2. What are you recycling?',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 4),
        Text('Bin: ${bin.name} (${bin.qrCode})',
            style:
                const TextStyle(fontSize: 12, color: Colors.black54)),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          children: [
            for (final c in WasteCategory.values)
              GCard(
                onTap: () => onPick(c),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(categoryIcon(c.label),
                        size: 40, color: categoryColor(c.label)),
                    const SizedBox(height: 8),
                    Text(c.label,
                        style:
                            const TextStyle(fontWeight: FontWeight.w700)),
                    Text('+${c.pointsPerItem} pts',
                        style: const TextStyle(
                            fontSize: 12, color: GColors.seed)),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _ScannerPanel extends StatelessWidget {
  const _ScannerPanel({
    required this.bin,
    required this.statusLine,
    required this.error,
    required this.qrController,
    required this.onSimulateScan,
    required this.onManualSubmit,
  });

  final SmartBin bin;
  final String statusLine;
  final String? error;
  final TextEditingController qrController;
  final VoidCallback onSimulateScan;
  final VoidCallback onManualSubmit;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('3. Scan the bin QR code',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        Container(
          height: 220,
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: GColors.leaf, width: 3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.qr_code_2,
                    size: 80, color: Colors.white54),
              ),
              Positioned(
                bottom: 16,
                child: Text(
                  statusLine.isEmpty
                      ? 'Point the camera at the bin sticker'
                      : statusLine,
                  style: const TextStyle(
                      color: Colors.white70, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          key: const Key('simulateScanButton'),
          onPressed: onSimulateScan,
          icon: const Icon(Icons.qr_code_scanner),
          label: const Text('Simulate scan'),
        ),
        const SizedBox(height: 16),
        const Text('Or enter the code printed on the bin:',
            style: TextStyle(fontSize: 12, color: Colors.black54)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: qrController,
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(
                  hintText: 'e.g. ${bin.qrCode}',
                ),
              ),
            ),
            const SizedBox(width: 8),
            FilledButton(
              onPressed: onManualSubmit,
              child: const Text('Verify'),
            ),
          ],
        ),
        if (error != null) ...[
          const SizedBox(height: 8),
          Text(error!, style: const TextStyle(color: Colors.red)),
        ],
      ],
    );
  }
}

class _ClassifyPanel extends StatelessWidget {
  const _ClassifyPanel({required this.statusLine});

  final String statusLine;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 72,
            height: 72,
            child: CircularProgressIndicator(strokeWidth: 5),
          ),
          const SizedBox(height: 24),
          Text(statusLine,
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          const Text('Smart bin AI is identifying the material',
              style: TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }
}

class _SortingPanel extends StatelessWidget {
  const _SortingPanel({
    required this.record,
    required this.countdown,
    required this.statusLine,
  });

  final WasteRecord record;
  final int countdown;
  final String statusLine;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: GCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(categoryIcon(record.category.label),
                  size: 56,
                  color: categoryColor(record.category.label)),
              const SizedBox(height: 12),
              Text('Detected: ${record.category.label}',
                  style: Theme.of(context).textTheme.titleLarge),
              Text(
                'Confidence: ${(record.confidence * 100).toStringAsFixed(1)}%',
                style: const TextStyle(
                    color: GColors.seed, fontWeight: FontWeight.w700),
              ),
              const Divider(height: 32),
              Text(statusLine,
                  style: const TextStyle(color: Colors.black54)),
              const SizedBox(height: 12),
              Text('$countdown',
                  key: const Key('servoCountdown'),
                  style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w800,
                      color: GColors.deepGreen)),
            ],
          ),
        ),
      ),
    );
  }
}

class _DonePanel extends StatelessWidget {
  const _DonePanel({required this.record, required this.onAgain});

  final WasteRecord record;
  final VoidCallback onAgain;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final counts = state.depositCounts;
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Icon(Icons.check_circle, size: 72, color: GColors.leaf),
        const SizedBox(height: 12),
        Text('+${record.pointsEarned} eco-points',
            key: const Key('depositResult'),
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.w800)),
        Text(
          '${record.category.label} - '
          '${record.weightKg.toStringAsFixed(2)} kg - '
          '${(record.confidence * 100).toStringAsFixed(1)}% confidence',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.black54),
        ),
        const SizedBox(height: 24),
        GCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Sorting statistics',
                  style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 12),
              for (final c in WasteCategory.values)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(categoryIcon(c.label),
                          size: 18, color: categoryColor(c.label)),
                      const SizedBox(width: 8),
                      Expanded(child: Text(c.label)),
                      Text('${counts[c]}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        FilledButton.icon(
          key: const Key('recycleAgainButton'),
          onPressed: onAgain,
          icon: const Icon(Icons.recycling),
          label: const Text('Recycle another item'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Back to Home'),
        ),
      ],
    );
  }
}

/// The bottom-nav "Recycle" tab starts the same flow without a
/// pre-selected bin.
class RecycleTabScreen extends StatelessWidget {
  const RecycleTabScreen({super.key});

  @override
  Widget build(BuildContext context) => const RecycleFlowScreen();
}
