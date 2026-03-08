import 'dart:math';
import 'package:flutter/material.dart';

enum VendorAvailability { offDuty, paused, active }

enum MotionSensitivity { low, medium, high }

enum RequestStatus { pending, accepted, arriving, declined, fulfilled }

class VendorProfile {
  VendorProfile({
    required this.name,
    required this.category,
    required this.cartType,
    this.serviceRadiusKm = 1.5,
    this.language = 'English',
  });

  String name;
  String category;
  String cartType;
  double serviceRadiusKm;
  String language;
}

class SilentBellRequest {
  SilentBellRequest({
    required this.id,
    required this.customerHex,
    required this.items,
    required this.createdAt,
    required this.distanceMeters,
    this.note,
    this.status = RequestStatus.pending,
    this.etaMinutes,
    this.lastQuickReply,
  });

  final String id;
  final String customerHex;
  final List<String> items;
  final DateTime createdAt;
  final int distanceMeters;
  final String? note;

  RequestStatus status;
  int? etaMinutes;
  String? lastQuickReply;
}

class TrackingSettings {
  TrackingSettings({
    this.motionSensitivity = MotionSensitivity.medium,
    this.gpsCadenceSecondsMoving = 15,
    this.dataCapMbPerDay = 120,
    this.fallbackMode = true,
  });

  MotionSensitivity motionSensitivity;
  int gpsCadenceSecondsMoving;
  int dataCapMbPerDay;
  bool fallbackMode;
}

class AppState extends ChangeNotifier {
  bool hasSeenOnboarding = false;
  bool isLoggedIn = false;
  String? boundDeviceId;

  VendorProfile? profile;
  VendorAvailability availability = VendorAvailability.offDuty;
  TrackingSettings tracking = TrackingSettings();

  DateTime? lastGpsPing;
  String currentH3Cell = '87283472bffffff';

  double batteryLevel = 0.72; // mock 0..1
  bool networkOnline = true; // mock

  final List<SilentBellRequest> _requests = [];

  List<SilentBellRequest> get requests {
    final copy = List<SilentBellRequest>.from(_requests);
    copy.sort((a, b) {
      final byDistance = a.distanceMeters.compareTo(b.distanceMeters);
      if (byDistance != 0) return byDistance;
      return b.createdAt.compareTo(a.createdAt);
    });
    return copy;
  }

  AppState() {
    _seedMock();
  }

  void _seedMock() {
    final now = DateTime.now();
    _requests.addAll([
      SilentBellRequest(
        id: 'req_1',
        customerHex: '87283472affffff',
        items: const ['Bananas', 'Guava'],
        createdAt: now.subtract(const Duration(minutes: 3)),
        distanceMeters: 140,
        note: 'Please stop near the temple corner.',
      ),
      SilentBellRequest(
        id: 'req_2',
        customerHex: '87283472bffffff',
        items: const ['Tomatoes', 'Coriander'],
        createdAt: now.subtract(const Duration(minutes: 7)),
        distanceMeters: 260,
      ),
      SilentBellRequest(
        id: 'req_3',
        customerHex: '87283472dffffff',
        items: const ['Jasmine flowers'],
        createdAt: now.subtract(const Duration(minutes: 11)),
        distanceMeters: 410,
        note: 'Need before 10 AM if possible.',
      ),
    ]);
    lastGpsPing = now.subtract(const Duration(minutes: 5));
    boundDeviceId = 'DEV-${100000 + Random().nextInt(900000)}';
  }

  void completeOnboarding(VendorProfile newProfile) {
    profile = newProfile;
    hasSeenOnboarding = true;
    notifyListeners();
  }

  void login({required String phoneNumber}) {
    isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    isLoggedIn = false;
    notifyListeners();
  }

  void setAvailability(VendorAvailability next) {
    availability = next;
    notifyListeners();
  }

  void setNetworkOnline(bool next) {
    if (networkOnline == next) return;
    networkOnline = next;
    notifyListeners();
  }

  void pingNow() {
    lastGpsPing = DateTime.now();
    notifyListeners();
  }

  SilentBellRequest? getRequestById(String id) {
    for (final r in _requests) {
      if (r.id == id) return r;
    }
    return null;
  }

  void acceptRequest(String id, {required int etaMinutes, String? quickReply}) {
    final r = getRequestById(id);
    if (r == null) return;
    r.status = RequestStatus.accepted;
    r.etaMinutes = etaMinutes;
    r.lastQuickReply = quickReply;
    notifyListeners();
  }

  void markArriving(String id) {
    final r = getRequestById(id);
    if (r == null) return;
    if (r.status != RequestStatus.accepted) return;
    r.status = RequestStatus.arriving;
    notifyListeners();
  }

  void markFulfilled(String id) {
    final r = getRequestById(id);
    if (r == null) return;
    if (r.status == RequestStatus.declined || r.status == RequestStatus.fulfilled) return;
    r.status = RequestStatus.fulfilled;
    notifyListeners();
  }

  void declineRequest(String id, {String? quickReply}) {
    final r = getRequestById(id);
    if (r == null) return;
    r.status = RequestStatus.declined;
    r.lastQuickReply = quickReply;
    notifyListeners();
  }

  void updateTracking(TrackingSettings next) {
    tracking = next;
    notifyListeners();
  }

  void updateProfile(VendorProfile next) {
    profile = next;
    notifyListeners();
  }
}

class AppStateScope extends InheritedNotifier<AppState> {
  const AppStateScope({super.key, required AppState state, required Widget child})
      : super(notifier: state, child: child);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppStateScope>();
    assert(scope != null, 'No AppStateScope found in context');
    return scope!.notifier!;
  }
}
