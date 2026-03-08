import 'dart:async';

import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:nirai_shared/nirai_theme.dart';

import '../../widgets/floating_dock.dart';
import '../app/app_state.dart';
import '../widgets/offline_banner.dart';
import 'discover_screen.dart';
import 'favorites_screen.dart';
import 'history_screen.dart';
import 'settings_screen.dart';

class ClientShell extends StatefulWidget {
  const ClientShell({super.key});

  @override
  State<ClientShell> createState() => _ClientShellState();
}

class _ClientShellState extends State<ClientShell> {
  int _index = 0;
  late final Stream<List<ConnectivityResult>> _connectivity = Connectivity().onConnectivityChanged;
  StreamSubscription<List<ConnectivityResult>>? _sub;
  AppState? _state;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _state ??= AppStateScope.of(context);
    _sub ??= _connectivity.listen((results) {
      final offline = results.isEmpty || results.every((r) => r == ConnectivityResult.none);
      _state?.setOffline(offline);
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
    final pages = <Widget>[
      const DiscoverScreen(),
      const FavoritesScreen(),
      const HistoryScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      backgroundColor: NiraiTheme.background,
      body: Stack(
        children: [
          Positioned.fill(child: pages[_index]),
          if (state.offline)
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: OfflineBanner(
                onRetry: () async {
                  final results = await Connectivity().checkConnectivity();
                  final offline = results.isEmpty || results.every((r) => r == ConnectivityResult.none);
                  state.setOffline(offline);
                },
              ),
            ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 18,
            child: SafeArea(
              top: false,
              child: Center(
                child: FloatingDock(
                  index: _index,
                  onChange: (i) => setState(() => _index = i),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
