// health_alert_service.dart
// Simulates a Twitter-like health alert API with:
//  - Realistic loading delay (fakes a network call)
//  - Pull-to-refresh injects 1–3 new alerts at the top
//  - shared_preferences cache so alerts survive app restarts
//
// ── Twitter API Credentials (v2) ──────────────────────────────────────────
// NOTE: Credentials are stored here for reference.
//       The app currently uses the offline hardcoded feed (no live API call).
//       To enable live Twitter/X API calls, wire these into an http request
//       using the bearer token in the Authorization header.
// ─────────────────────────────────────────────────────────────────────────

import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/health_alerts_data.dart';

class HealthAlertService {
  // ── Twitter / X API v2 Credentials ─────────────────────────────────────
  // ignore: unused_field
  static const String _twitterApiKey = 'zH4rK9FGGEOBolBcxk9niZNGS';

  // ignore: unused_field
  static const String _twitterApiKeySecret =
      'KYpIp629vlvgRlOAKix3zNRJ0EY3f2qfKGOnwFyqASTNaDEBMp';

  // Used in Authorization: Bearer <token> header for Twitter API v2 requests
  // ignore: unused_field
  static const String _twitterBearerToken =
      'AAAAAAAAAAAAAAAAAAAAAOMV4QEAAAAA%2FxT9%2FbPN%2BQ2xEyHVKxKWkfOHQqA%3D'
      '9mWEQv5uLwCtQvvyAhJ3KkLHkXTgGV8ZQxaGH23f5344JJLMUd';

  // Twitter v2 search endpoint — health tweets endpoint (reference only)
  // ignore: unused_field
  static const String _twitterSearchUrl =
      'https://api.twitter.com/2/tweets/search/recent';

  // ── Cache keys ──────────────────────────────────────────────────────────
  static const String _cacheKey = 'cached_health_alerts';
  static const String _refreshCountKey = 'alert_refresh_count';

  // Track which refresh-pool alerts we've already used
  static int _refreshPoolCursor = 0;

  // ── Load from cache or return initial set ──────────────────────────────
  static Future<List<HealthAlert>> loadAlerts() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_cacheKey);

    if (raw != null) {
      try {
        final List decoded = jsonDecode(raw);
        return decoded.map((e) => HealthAlert.fromJson(e)).toList();
      } catch (_) {
        // Cache corrupted — fall through to initial set
      }
    }

    // First launch: return initial 10 alerts
    final initial = kInitialAlertIndices
        .map((i) => kAlertPool[i])
        .toList();
    await _saveToCache(prefs, initial);
    return initial;
  }

  // ── Simulate API call (with fake network delay) ────────────────────────
  // Returns the NEW updated list after injecting fresh alerts at the top.
  static Future<List<HealthAlert>> refresh(
      List<HealthAlert> current) async {
    // Simulate network latency (1.2 – 2.5 seconds)
    final delay = 1200 + Random().nextInt(1300);
    await Future.delayed(Duration(milliseconds: delay));

    final prefs = await SharedPreferences.getInstance();

    // How many refreshes have happened so far?
    final refreshCount = (prefs.getInt(_refreshCountKey) ?? 0) + 1;
    await prefs.setInt(_refreshCountKey, refreshCount);

    // Every refresh injects 1–3 new alerts at the top
    final newCount = 1 + Random().nextInt(3); // 1, 2, or 3
    final newAlerts = <HealthAlert>[];

    for (int i = 0; i < newCount; i++) {
      if (kRefreshAlertIndices.isEmpty) break;
      final idx =
          kRefreshAlertIndices[_refreshPoolCursor % kRefreshAlertIndices.length];
      _refreshPoolCursor++;

      final base = kAlertPool[idx];
      // Stamp a fresh "just now" / "Xm ago" time label
      newAlerts.add(HealthAlert(
        id: '${base.id}_r$refreshCount$i',
        title: base.title,
        body: base.body,
        source: base.source,
        handle: base.handle,
        category: base.category,
        timeAgo: _freshTimeLabel(i),
        likes: base.likes + Random().nextInt(500),
        retweets: base.retweets + Random().nextInt(200),
      ));
    }

    // Prepend new alerts, keep up to 30 total
    final updated = [...newAlerts, ...current];
    final trimmed = updated.take(30).toList();

    await _saveToCache(prefs, trimmed);
    return trimmed;
  }

  // ── Persist to cache ───────────────────────────────────────────────────
  static Future<void> _saveToCache(
      SharedPreferences prefs, List<HealthAlert> alerts) async {
    final encoded = jsonEncode(alerts.map((a) => a.toJson()).toList());
    await prefs.setString(_cacheKey, encoded);
  }

  // ── Clear cache (useful for testing) ──────────────────────────────────
  static Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey);
    await prefs.remove(_refreshCountKey);
  }

  // ── Helper: fresh-looking timestamp ───────────────────────────────────
  static String _freshTimeLabel(int offset) {
    final labels = ['just now', '1m ago', '2m ago', '3m ago', '5m ago'];
    return labels[offset % labels.length];
  }
}
