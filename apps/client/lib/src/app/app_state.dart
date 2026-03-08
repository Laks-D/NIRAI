import 'package:flutter/widgets.dart';

enum RequestStatus {
  sent,
  seen,
  accepted,
  arriving,
  completed,
}

class VendorSummary {
  const VendorSummary({
    required this.id,
    required this.name,
    required this.category,
    required this.distanceLabel,
    required this.hexLabel,
    required this.isActive,
    required this.supportsBargaining,
  });

  final String id;
  final String name;
  final String category;
  final String distanceLabel;
  final String hexLabel;
  final bool isActive;
  final bool supportsBargaining;
}

class SilentBellRequest {
  const SilentBellRequest({
    required this.id,
    required this.vendorId,
    required this.vendorName,
    required this.createdAt,
    required this.typeLabel,
    required this.note,
    required this.timeWindowLabel,
    required this.status,
  });

  final String id;
  final String vendorId;
  final String vendorName;
  final DateTime createdAt;
  final String typeLabel;
  final String note;
  final String timeWindowLabel;
  final RequestStatus status;
}

class AppState extends ChangeNotifier {
  AppState({
    required this.hasCompletedOnboarding,
    required this.isLoggedIn,
    required this.isGuest,
    required this.localityLabel,
    required this.hexLabel,
    required this.languageLabel,
    required this.dataSaverEnabled,
    required this.offline,
    required List<VendorSummary> vendors,
    required Set<String> favoriteVendorIds,
    required List<SilentBellRequest> history,
  })  : _vendors = List.unmodifiable(vendors),
        _favoriteVendorIds = {...favoriteVendorIds},
        _history = List.unmodifiable(history);

  factory AppState.seeded() {
    final vendors = <VendorSummary>[
      const VendorSummary(
        id: 'v_anjali',
        name: 'Anjali Fruit Cart',
        category: 'Fruits',
        distanceLabel: '150m',
        hexLabel: 'Hex Res-7',
        isActive: true,
        supportsBargaining: true,
      ),
      const VendorSummary(
        id: 'v_murugan',
        name: 'Murugan Veggie Stand',
        category: 'Veggies',
        distanceLabel: '280m',
        hexLabel: 'Hex Res-7',
        isActive: true,
        supportsBargaining: false,
      ),
      const VendorSummary(
        id: 'v_kaveri',
        name: 'Kaveri Flower Shop',
        category: 'Flowers',
        distanceLabel: '90m',
        hexLabel: 'Hex Res-7',
        isActive: false,
        supportsBargaining: true,
      ),
      const VendorSummary(
        id: 'v_selvi',
        name: 'Selvi Greens',
        category: 'Veggies',
        distanceLabel: '410m',
        hexLabel: 'Hex Res-7',
        isActive: true,
        supportsBargaining: false,
      ),
    ];

    return AppState(
      hasCompletedOnboarding: false,
      isLoggedIn: false,
      isGuest: false,
      localityLabel: 'Kotturpuram, Chennai',
      hexLabel: 'Hex Res-7',
      languageLabel: 'English',
      dataSaverEnabled: true,
      offline: false,
      vendors: vendors,
      favoriteVendorIds: const {'v_anjali'},
      history: const [],
    );
  }

  bool hasCompletedOnboarding;
  bool isLoggedIn;
  bool isGuest;
  bool offline;

  String localityLabel;
  String hexLabel;
  String languageLabel;
  bool dataSaverEnabled;

  final List<VendorSummary> _vendors;
  Set<String> _favoriteVendorIds;
  List<SilentBellRequest> _history;

  List<VendorSummary> get vendors => _vendors;
  Set<String> get favoriteVendorIds => _favoriteVendorIds;
  List<SilentBellRequest> get history => _history;

  VendorSummary? vendorById(String id) {
    for (final v in _vendors) {
      if (v.id == id) return v;
    }
    return null;
  }

  void completeOnboarding() {
    hasCompletedOnboarding = true;
    notifyListeners();
  }

  void loginWithPhone(String phoneE164OrLocal) {
    isLoggedIn = true;
    isGuest = false;
    notifyListeners();
  }

  void continueAsGuest() {
    isLoggedIn = true;
    isGuest = true;
    notifyListeners();
  }

  void logout() {
    isLoggedIn = false;
    isGuest = false;
    notifyListeners();
  }

  void setLocality({required String locality, required String hex}) {
    localityLabel = locality;
    hexLabel = hex;
    notifyListeners();
  }

  void setLanguage(String value) {
    languageLabel = value;
    notifyListeners();
  }

  void setDataSaver(bool value) {
    dataSaverEnabled = value;
    notifyListeners();
  }

  void setOffline(bool value) {
    if (offline == value) return;
    offline = value;
    notifyListeners();
  }

  void toggleFavorite(String vendorId) {
    final next = {..._favoriteVendorIds};
    if (next.contains(vendorId)) {
      next.remove(vendorId);
    } else {
      next.add(vendorId);
    }
    _favoriteVendorIds = next;
    notifyListeners();
  }

  SilentBellRequest createSilentBell({
    required String vendorId,
    required String typeLabel,
    required String note,
    required String timeWindowLabel,
  }) {
    final vendor = vendorById(vendorId);
    final request = SilentBellRequest(
      id: 'r_${DateTime.now().millisecondsSinceEpoch}',
      vendorId: vendorId,
      vendorName: vendor?.name ?? 'Vendor',
      createdAt: DateTime.now(),
      typeLabel: typeLabel,
      note: note,
      timeWindowLabel: timeWindowLabel,
      status: RequestStatus.sent,
    );

    _history = [request, ..._history];
    notifyListeners();
    return request;
  }

  void updateRequestStatus(String requestId, RequestStatus status) {
    final next = <SilentBellRequest>[];
    for (final r in _history) {
      if (r.id == requestId) {
        next.add(SilentBellRequest(
          id: r.id,
          vendorId: r.vendorId,
          vendorName: r.vendorName,
          createdAt: r.createdAt,
          typeLabel: r.typeLabel,
          note: r.note,
          timeWindowLabel: r.timeWindowLabel,
          status: status,
        ));
      } else {
        next.add(r);
      }
    }
    _history = List.unmodifiable(next);
    notifyListeners();
  }
}

class AppStateScope extends InheritedNotifier<AppState> {
  const AppStateScope({super.key, required super.notifier, required super.child});

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppStateScope>();
    assert(scope != null, 'No AppStateScope found in context');
    return scope!.notifier!;
  }
}
