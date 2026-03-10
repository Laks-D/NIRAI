import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'app_state.dart';

const _kPrefix = 'nirai.client.';

const _kHasOnboarded = '${_kPrefix}hasCompletedOnboarding';
const _kIsLoggedIn = '${_kPrefix}isLoggedIn';
const _kIsGuest = '${_kPrefix}isGuest';
const _kLocality = '${_kPrefix}localityLabel';
const _kHex = '${_kPrefix}hexLabel';
const _kLanguage = '${_kPrefix}languageLabel';
const _kDataSaver = '${_kPrefix}dataSaverEnabled';
const _kFavorites = '${_kPrefix}favoriteVendorIds';
const _kHistory = '${_kPrefix}history';

class AppStatePersistence {
  AppStatePersistence._(this._prefs, this._state, this._onSave);

  final SharedPreferences _prefs;
  final AppState _state;
  final VoidCallback _onSave;

  Timer? _debounce;

  static Future<AppState> load(SharedPreferences prefs) async {
    final state = AppState.seeded();

    state.hasCompletedOnboarding = prefs.getBool(_kHasOnboarded) ?? state.hasCompletedOnboarding;
    state.isLoggedIn = prefs.getBool(_kIsLoggedIn) ?? state.isLoggedIn;
    state.isGuest = prefs.getBool(_kIsGuest) ?? state.isGuest;

    state.localityLabel = prefs.getString(_kLocality) ?? state.localityLabel;
    state.hexLabel = prefs.getString(_kHex) ?? state.hexLabel;
    state.languageLabel = prefs.getString(_kLanguage) ?? state.languageLabel;
    state.dataSaverEnabled = prefs.getBool(_kDataSaver) ?? state.dataSaverEnabled;

    final favs = prefs.getStringList(_kFavorites);
    if (favs != null) {
      state.replaceFavorites(favs.toSet());
    }

    final historyRaw = prefs.getStringList(_kHistory);
    if (historyRaw != null) {
      final parsed = <SilentBellRequest>[];
      for (final s in historyRaw) {
        try {
          final m = jsonDecode(s) as Map<String, dynamic>;
          parsed.add(SilentBellRequest(
            id: (m['id'] as String?) ?? 'r_unknown',
            vendorId: (m['vendorId'] as String?) ?? 'v_unknown',
            vendorName: (m['vendorName'] as String?) ?? 'Vendor',
            createdAt: DateTime.fromMillisecondsSinceEpoch((m['createdAtMs'] as int?) ?? 0),
            typeLabel: (m['typeLabel'] as String?) ?? 'Request',
            note: (m['note'] as String?) ?? '',
            timeWindowLabel: (m['timeWindowLabel'] as String?) ?? '—',
            status: RequestStatus.values[(m['status'] as int?) ?? 0],
          ));
        } catch (_) {
          // Ignore malformed entries.
        }
      }
      state.replaceHistory(parsed);
    }

    return state;
  }

  static AppStatePersistence bind({required SharedPreferences prefs, required AppState state}) {
    final binder = AppStatePersistence._(prefs, state, () {});
    void save() {
      binder._debounce?.cancel();
      binder._debounce = Timer(const Duration(milliseconds: 250), () {
        binder._saveNow();
      });
    }

    state.addListener(save);
    return AppStatePersistence._(prefs, state, () => state.removeListener(save));
  }

  Future<void> clearAll() async {
    await _prefs.remove(_kHasOnboarded);
    await _prefs.remove(_kIsLoggedIn);
    await _prefs.remove(_kIsGuest);
    await _prefs.remove(_kLocality);
    await _prefs.remove(_kHex);
    await _prefs.remove(_kLanguage);
    await _prefs.remove(_kDataSaver);
    await _prefs.remove(_kFavorites);
    await _prefs.remove(_kHistory);
  }

  Future<void> clearAuth() async {
    await _prefs.setBool(_kIsLoggedIn, false);
    await _prefs.setBool(_kIsGuest, false);
  }

  void dispose() {
    _debounce?.cancel();
    _onSave();
  }

  Future<void> _saveNow() async {
    await _prefs.setBool(_kHasOnboarded, _state.hasCompletedOnboarding);
    await _prefs.setBool(_kIsLoggedIn, _state.isLoggedIn);
    await _prefs.setBool(_kIsGuest, _state.isGuest);

    await _prefs.setString(_kLocality, _state.localityLabel);
    await _prefs.setString(_kHex, _state.hexLabel);
    await _prefs.setString(_kLanguage, _state.languageLabel);
    await _prefs.setBool(_kDataSaver, _state.dataSaverEnabled);

    await _prefs.setStringList(_kFavorites, _state.favoriteVendorIds.toList(growable: false));

    final history = _state.history
        .map((r) => jsonEncode({
              'id': r.id,
              'vendorId': r.vendorId,
              'vendorName': r.vendorName,
              'createdAtMs': r.createdAt.millisecondsSinceEpoch,
              'typeLabel': r.typeLabel,
              'note': r.note,
              'timeWindowLabel': r.timeWindowLabel,
              'status': r.status.index,
            }))
        .toList(growable: false);
    await _prefs.setStringList(_kHistory, history);
  }
}
