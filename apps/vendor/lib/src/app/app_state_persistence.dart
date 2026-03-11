import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

import 'app_state.dart';

const _kPrefix = 'nirai.vendor.';

const _kHasSeenOnboarding = '${_kPrefix}hasSeenOnboarding';
const _kIsLoggedIn = '${_kPrefix}isLoggedIn';
const _kBoundDeviceId = '${_kPrefix}boundDeviceId';

const _kProfileName = '${_kPrefix}profile.name';
const _kProfileCategory = '${_kPrefix}profile.category';
const _kProfileCartType = '${_kPrefix}profile.cartType';
const _kProfileRadiusKm = '${_kPrefix}profile.serviceRadiusKm';
const _kProfileLanguage = '${_kPrefix}profile.language';

const _kAvailability = '${_kPrefix}availability';

const _kMotionSensitivity = '${_kPrefix}tracking.motionSensitivity';
const _kGpsCadence = '${_kPrefix}tracking.gpsCadenceSecondsMoving';
const _kDataCap = '${_kPrefix}tracking.dataCapMbPerDay';
const _kFallbackMode = '${_kPrefix}tracking.fallbackMode';

class AppStatePersistence {
  AppStatePersistence._(this._prefs, this._state);

  final SharedPreferences _prefs;
  final AppState _state;
  late final void Function() _unbind;

  Timer? _debounce;

  static Future<AppState> load(SharedPreferences prefs) async {
    final state = AppState();

    state.hasSeenOnboarding = prefs.getBool(_kHasSeenOnboarding) ?? state.hasSeenOnboarding;
    state.isLoggedIn = prefs.getBool(_kIsLoggedIn) ?? state.isLoggedIn;
    state.boundDeviceId = prefs.getString(_kBoundDeviceId) ?? state.boundDeviceId;

    final name = prefs.getString(_kProfileName);
    final category = prefs.getString(_kProfileCategory);
    final cartType = prefs.getString(_kProfileCartType);
    if (name != null && category != null && cartType != null) {
      state.profile = VendorProfile(
        name: name,
        category: category,
        cartType: cartType,
        serviceRadiusKm: prefs.getDouble(_kProfileRadiusKm) ?? 1.5,
        language: prefs.getString(_kProfileLanguage) ?? 'English',
      );
    }

    final availabilityIndex = prefs.getInt(_kAvailability);
    if (availabilityIndex != null && availabilityIndex >= 0 && availabilityIndex < VendorAvailability.values.length) {
      state.availability = VendorAvailability.values[availabilityIndex];
    }

    final motionIndex = prefs.getInt(_kMotionSensitivity);
    if (motionIndex != null && motionIndex >= 0 && motionIndex < MotionSensitivity.values.length) {
      state.tracking.motionSensitivity = MotionSensitivity.values[motionIndex];
    }
    state.tracking.gpsCadenceSecondsMoving = prefs.getInt(_kGpsCadence) ?? state.tracking.gpsCadenceSecondsMoving;
    state.tracking.dataCapMbPerDay = prefs.getInt(_kDataCap) ?? state.tracking.dataCapMbPerDay;
    state.tracking.fallbackMode = prefs.getBool(_kFallbackMode) ?? state.tracking.fallbackMode;

    return state;
  }

  static AppStatePersistence bind({required SharedPreferences prefs, required AppState state}) {
    final persistence = AppStatePersistence._(prefs, state);
    void save() {
      persistence._debounce?.cancel();
      persistence._debounce = Timer(const Duration(milliseconds: 250), () {
        persistence._saveNow();
      });
    }

    state.addListener(save);
    persistence._unbind = () => state.removeListener(save);
    return persistence;
  }

  Future<void> clearAll() async {
    await _prefs.remove(_kHasSeenOnboarding);
    await _prefs.remove(_kIsLoggedIn);
    await _prefs.remove(_kBoundDeviceId);

    await _prefs.remove(_kProfileName);
    await _prefs.remove(_kProfileCategory);
    await _prefs.remove(_kProfileCartType);
    await _prefs.remove(_kProfileRadiusKm);
    await _prefs.remove(_kProfileLanguage);

    await _prefs.remove(_kAvailability);

    await _prefs.remove(_kMotionSensitivity);
    await _prefs.remove(_kGpsCadence);
    await _prefs.remove(_kDataCap);
    await _prefs.remove(_kFallbackMode);
  }

  Future<void> clearAuth() async {
    await _prefs.setBool(_kIsLoggedIn, false);
  }

  void dispose() {
    _debounce?.cancel();
    _unbind();
  }

  Future<void> _saveNow() async {
    await _prefs.setBool(_kHasSeenOnboarding, _state.hasSeenOnboarding);
    await _prefs.setBool(_kIsLoggedIn, _state.isLoggedIn);
    if (_state.boundDeviceId != null) {
      await _prefs.setString(_kBoundDeviceId, _state.boundDeviceId!);
    }

    final profile = _state.profile;
    if (profile != null) {
      await _prefs.setString(_kProfileName, profile.name);
      await _prefs.setString(_kProfileCategory, profile.category);
      await _prefs.setString(_kProfileCartType, profile.cartType);
      await _prefs.setDouble(_kProfileRadiusKm, profile.serviceRadiusKm);
      await _prefs.setString(_kProfileLanguage, profile.language);
    }

    await _prefs.setInt(_kAvailability, _state.availability.index);

    await _prefs.setInt(_kMotionSensitivity, _state.tracking.motionSensitivity.index);
    await _prefs.setInt(_kGpsCadence, _state.tracking.gpsCadenceSecondsMoving);
    await _prefs.setInt(_kDataCap, _state.tracking.dataCapMbPerDay);
    await _prefs.setBool(_kFallbackMode, _state.tracking.fallbackMode);
  }
}
