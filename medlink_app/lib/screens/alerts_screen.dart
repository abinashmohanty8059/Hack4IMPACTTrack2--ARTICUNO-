import 'package:flutter/material.dart';
import '../data/health_alerts_data.dart';
import '../services/health_alert_service.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  List<HealthAlert> _alerts = [];
  bool _isLoading = true;
  int _refreshCount = 0;
  int _newAlertsOnLastRefresh = 0;
  bool _showNewBanner = false;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final cached = await HealthAlertService.loadAlerts();
    if (mounted) {
      setState(() {
        _alerts = cached;
        _isLoading = false;
      });
    }
  }

  Future<void> _onRefresh() async {
    final before = _alerts.length;
    final updated = await HealthAlertService.refresh(_alerts);
    if (!mounted) return;

    setState(() {
      _refreshCount++;
      _newAlertsOnLastRefresh = updated.length - before;
      if (_newAlertsOnLastRefresh < 0) _newAlertsOnLastRefresh = 0;
      _alerts = updated;
      _showNewBanner = _newAlertsOnLastRefresh > 0;
    });

    // Auto-hide the "new alerts" banner after 3 seconds
    if (_showNewBanner) {
      await Future.delayed(const Duration(seconds: 3));
      if (mounted) setState(() => _showNewBanner = false);
    }
  }

  // ─── Category badge colour ───────────────────────────────────────────────
  Color _categoryColor(String cat) {
    switch (cat) {
      case 'vaccination':
        return const Color(0xFF29B6F6);
      case 'alert':
        return const Color(0xFFEF5350);
      case 'camp':
        return const Color(0xFF66BB6A);
      case 'program':
        return const Color(0xFFAB47BC);
      default:
        return Colors.teal;
    }
  }

  IconData _categoryIcon(String cat) {
    switch (cat) {
      case 'vaccination':
        return Icons.vaccines_outlined;
      case 'alert':
        return Icons.warning_amber_rounded;
      case 'camp':
        return Icons.local_hospital_outlined;
      case 'program':
        return Icons.health_and_safety_outlined;
      default:
        return Icons.campaign_outlined;
    }
  }

  // ─── Single tweet-card ───────────────────────────────────────────────────
  Widget _buildCard(HealthAlert alert, bool isNew) {
    final cat = alert.category;
    final color = _categoryColor(cat);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: isNew
            ? color.withOpacity(0.08)
            : const Color(0xFF111111),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isNew ? color.withOpacity(0.45) : Colors.white12,
          width: isNew ? 1.5 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header row ──────────────────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Avatar circle
                CircleAvatar(
                  radius: 18,
                  backgroundColor: color.withOpacity(0.20),
                  child: Icon(_categoryIcon(cat), color: color, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              alert.source,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          // Verified tick
                          Icon(Icons.verified,
                              size: 13, color: const Color(0xFF1DA1F2)),
                        ],
                      ),
                      Text(
                        '${alert.handle} · ${alert.timeAgo}',
                        style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                // Category badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: color.withOpacity(0.4), width: 1),
                  ),
                  child: Text(
                    cat.toUpperCase(),
                    style: TextStyle(
                      color: color,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // ── Title ───────────────────────────────────────────────────
            Text(
              alert.title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
                height: 1.3,
              ),
            ),

            const SizedBox(height: 6),

            // ── Body ────────────────────────────────────────────────────
            Text(
              alert.body,
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 13,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 10),
            const Divider(color: Colors.white10, height: 1),
            const SizedBox(height: 8),

            // ── Footer: likes, retweets ──────────────────────────────────
            Row(
              children: [
                _statChip(Icons.favorite_border,
                    _formatNum(alert.likes), Colors.pink),
                const SizedBox(width: 20),
                _statChip(Icons.repeat, _formatNum(alert.retweets),
                    const Color(0xFF1DA1F2)),
                const Spacer(),
                if (isNew)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'NEW',
                      style: TextStyle(
                        color: color,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statChip(IconData icon, String label, Color color) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color.withOpacity(0.8)),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(color: Colors.white54, fontSize: 12),
        ),
      ],
    );
  }

  String _formatNum(int n) {
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return '$n';
  }

  // ─── New alerts banner ───────────────────────────────────────────────────
  Widget _newAlertsBanner() {
    return AnimatedSlide(
      offset: _showNewBanner ? Offset.zero : const Offset(0, -1),
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
      child: AnimatedOpacity(
        opacity: _showNewBanner ? 1 : 0,
        duration: const Duration(milliseconds: 300),
        child: GestureDetector(
          onTap: () {
            _scrollController.animateTo(0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOut);
            setState(() => _showNewBanner = false);
          },
          child: Container(
            margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1DA1F2), Color(0xFF0D8ECF)],
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1DA1F2).withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.arrow_upward,
                    color: Colors.white, size: 16),
                const SizedBox(width: 8),
                Text(
                  '$_newAlertsOnLastRefresh new health update${_newAlertsOnLastRefresh > 1 ? 's' : ''}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── Build ───────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050A0E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF050A0E),
        elevation: 0,
        centerTitle: false,
        title: Row(
          children: [
            const Icon(Icons.health_and_safety,
                color: Color(0xFF1DA1F2), size: 22),
            const SizedBox(width: 8),
            const Text(
              'Health Feed',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          // Live badge
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.red.withOpacity(0.5)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(width: 5),
                const Text(
                  'LIVE',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.white12, height: 1),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                      color: Color(0xFF1DA1F2), strokeWidth: 2),
                  SizedBox(height: 16),
                  Text('Fetching health updates…',
                      style: TextStyle(color: Colors.white38, fontSize: 13)),
                ],
              ),
            )
          : Column(
              children: [
                // "X new alerts" banner
                Center(child: _newAlertsBanner()),

                // Refresh hint row
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Row(
                    children: [
                      Text(
                        '${_alerts.length} updates  ·  pull down to refresh',
                        style: const TextStyle(
                            color: Colors.white24, fontSize: 11),
                      ),
                      const Spacer(),
                      if (_refreshCount > 0)
                        Text(
                          'refreshed $_refreshCount×',
                          style: const TextStyle(
                              color: Colors.white24, fontSize: 11),
                        ),
                    ],
                  ),
                ),

                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _onRefresh,
                    color: const Color(0xFF1DA1F2),
                    backgroundColor: const Color(0xFF111111),
                    strokeWidth: 2.5,
                    child: ListView.builder(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: _alerts.length,
                      itemBuilder: (context, index) {
                        final alert = _alerts[index];
                        // Mark alerts added after the last refresh as "new"
                        final isNew =
                            index < _newAlertsOnLastRefresh && _showNewBanner;
                        return _buildCard(alert, isNew);
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
