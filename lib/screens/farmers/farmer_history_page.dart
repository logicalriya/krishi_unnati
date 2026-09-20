import 'package:flutter/material.dart';

import '../../services/local_db.dart';
import '../../state/app_locale.dart';

class FarmerHistoryPage extends StatefulWidget {
  const FarmerHistoryPage({super.key});

  @override
  State<FarmerHistoryPage> createState() => _FarmerHistoryPageState();
}

class _FarmerHistoryPageState extends State<FarmerHistoryPage> {
  late Future<List<Map<String, dynamic>>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    _historyFuture = LocalDb.getHistory();
  }

  Future<void> _clearHistory() async {
    final t = AppLocale.of(context).t;
    final shouldClear = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t('clearHistory')),
        content: Text(t('clearHistoryConfirm')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(t('cancel')),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(t('clearHistory')),
          ),
        ],
      ),
    );

    if (shouldClear != true) return;
    await LocalDb.clearHistory();
    if (!mounted) return;
    setState(_reload);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocale.of(context).t;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F8F4),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF18352A),
        elevation: 0,
        title: Text(
          t('scanHistory'),
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            tooltip: t('clearHistory'),
            onPressed: _clearHistory,
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _historyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF2E7D4F),
              ),
            );
          }

          final entries = snapshot.data ?? const <Map<String, dynamic>>[];
          if (entries.isEmpty) {
            return _EmptyHistory(t: t);
          }

          return RefreshIndicator(
            onRefresh: () async {
              setState(_reload);
              await _historyFuture;
            },
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
              itemCount: entries.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) => _HistoryCard(
                entry: entries[index],
                translate: t,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final Map<String, dynamic> entry;
  final String Function(String) translate;

  const _HistoryCard({required this.entry, required this.translate});

  @override
  Widget build(BuildContext context) {
    final type = (entry['type'] ?? 'scan').toString();
    final title = (entry['disease'] ?? entry['title'] ?? translate('scanResult')).toString();
    final confidence = entry['confidence'];
    final timestamp = DateTime.tryParse((entry['timestamp'] ?? '').toString());
    final icon = type == 'pest_report'
        ? Icons.bug_report_outlined
        : Icons.eco_outlined;
    final date = timestamp == null ? '' : _formatDate(timestamp);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFD5E4D9)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFE3F1E8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF2E7D4F),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type == 'pest_report'
                      ? translate('pestReport')
                      : translate('cropScan'),
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF2E7D4F),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF18352A),
                  ),
                ),
                if (confidence != null)
                  Text(
                    '${translate('confidence')}: $confidence',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF68756D),
                    ),
                  ),
              ],
            ),
          ),
          if (date.isNotEmpty)
            Text(
              date,
              style: const TextStyle(
                fontSize: 10,
                color: Color(0xFF68756D),
              ),
            ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}

class _EmptyHistory extends StatelessWidget {
  final String Function(String) t;

  const _EmptyHistory({required this.t});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.history,
              size: 64,
              color: Color(0xFF8EA095),
            ),
            const SizedBox(height: 14),
            Text(
              t('noScansYet'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF52665A),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}