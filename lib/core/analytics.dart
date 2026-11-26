import 'package:flutter/foundation.dart';
import 'package:flouka/core/env.dart';

/// Analytics facade. Nothing is sent until [start] after consent.
class FkAnalytics {
  FkAnalytics({FkEnv? env}) : env = env ?? FkEnv.instance;

  final FkEnv env;
  bool _started = false;
  final List<Map<String, Object?>> log = [];
  Future<void> Function()? onStart;
  Future<void> Function(String name, Map<String, Object?> props)? onEvent;

  bool get started => _started;

  Future<void> start() async {
    if (_started) return;
    _started = true;
    if (onStart != null) {
      await onStart!();
      return;
    }
    await _startSdks();
  }

  Future<void> event(String name, [Map<String, Object?> props = const {}]) async {
    log.add({'name': name, ...props});
    if (!_started) return;
    if (onEvent != null) {
      await onEvent!(name, props);
      return;
    }
    debugPrint('analytics $name $props');
  }

  Future<void> _startSdks() async {
    if (env.hasPosthog) {
      await _startPosthog();
    }
    if (env.hasClarity) {
      await _startClarity();
    }
    if (env.hasFirebase) {
      await _startFirebase();
    }
  }

  Future<void> _startPosthog() async {
    try {
      // ignore: avoid_dynamic_calls
      final posthog = await _load('package:posthog_flutter/posthog_flutter.dart');
      debugPrint('PostHog available: ${posthog != null} host=${env.posthogHost}');
    } catch (e) {
      debugPrint('PostHog skipped: $e');
    }
  }

  Future<void> _startClarity() async {
    try {
      debugPrint('Clarity would start project=${env.clarityId}');
    } catch (e) {
      debugPrint('Clarity skipped: $e');
    }
  }

  Future<void> _startFirebase() async {
    try {
      debugPrint('Firebase Analytics would start project=${env.firebaseProjectId}');
    } catch (e) {
      debugPrint('Firebase skipped: $e');
    }
  }

  Future<Object?> _load(String uri) async => null;

  void resetForTest() {
    _started = false;
    log.clear();
  }
}
