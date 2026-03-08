import 'package:flutter/material.dart';
import 'package:nirai_shared/nirai_theme.dart';
import 'package:nirai_shared/portal_scope.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:nirai_client/portal.dart' as client;
import 'package:nirai_vendor/portal.dart' as vendor;

import 'landing/landing_screen.dart';

const _prefsKeyDefaultRole = 'nirai.defaultRole';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  final saved = prefs.getString(_prefsKeyDefaultRole);
  final savedRole = saved == 'vendor' ? PortalRole.vendor : PortalRole.client;

  runApp(NiraiApp(defaultRole: savedRole, prefs: prefs));
}

class NiraiApp extends StatefulWidget {
  const NiraiApp({super.key, required this.defaultRole, required this.prefs});

  final PortalRole defaultRole;
  final SharedPreferences prefs;

  @override
  State<NiraiApp> createState() => _NiraiAppState();
}

class _NiraiAppState extends State<NiraiApp> {
  late final PortalController _portal = PortalController(role: widget.defaultRole);
  late final client.AppState _clientState = client.AppState.seeded();
  late final vendor.AppState _vendorState = vendor.AppState();

  @override
  void initState() {
    super.initState();
    _portal.addListener(_persistDefault);
  }

  void _persistDefault() {
    final v = _portal.defaultRole == PortalRole.vendor ? 'vendor' : 'client';
    widget.prefs.setString(_prefsKeyDefaultRole, v);
  }

  @override
  void dispose() {
    _portal.removeListener(_persistDefault);
    _portal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final portalHome = _portal.role == PortalRole.vendor ? const vendor.AppShell() : const client.AppShell();

    Widget app = MaterialApp(
      key: ValueKey(_portal.role),
      debugShowCheckedModeBanner: false,
      theme: NiraiTheme.theme(),
      home: LandingScreen(next: portalHome),
    );

    // Critical: scopes must be ABOVE MaterialApp so pushed routes can read state.
    if (_portal.role == PortalRole.vendor) {
      app = vendor.AppStateScope(state: _vendorState, child: app);
    } else {
      app = client.AppStateScope(notifier: _clientState, child: app);
    }

    return PortalScope(
      controller: _portal,
      child: app,
    );
  }
}
