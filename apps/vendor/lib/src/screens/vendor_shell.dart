import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nirai_shared/nirai_theme.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../app/app_state.dart';
import '../widgets/offline_banner.dart';
import 'go_live_screen.dart';
import 'requests_inbox_screen.dart';
import 'settings_screen.dart';

class VendorShell extends StatefulWidget {
  const VendorShell({super.key});

  @override
  State<VendorShell> createState() => _VendorShellState();
}

class _VendorShellState extends State<VendorShell> {
  int _index = 0;
  StreamSubscription<List<ConnectivityResult>>? _sub;
  AppState? _state;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _state ??= AppStateScope.of(context);
    _sub ??= Connectivity().onConnectivityChanged.listen((results) {
      final online = results.isNotEmpty && !results.contains(ConnectivityResult.none);
      _state?.setNetworkOnline(online);
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    return Scaffold(
      backgroundColor: NiraiTheme.background,
      body: Stack(
        children: [
          IndexedStack(
            index: _index,
            children: const [
              GoLiveScreen(),
              RequestsInboxScreen(),
              SettingsScreen(),
            ],
          ),
          if (!state.networkOnline) const OfflineBanner(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: NiraiTheme.background,
        indicatorColor: NiraiTheme.accent.withOpacity(0.55),
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.radio_button_checked_outlined), label: 'Go Live'),
          NavigationDestination(icon: Icon(Icons.notifications_active_outlined), label: 'Requests'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), label: 'Settings'),
        ],
      ),
    );
  }
}
