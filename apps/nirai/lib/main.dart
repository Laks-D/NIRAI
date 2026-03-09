import 'package:flutter/material.dart';
import 'package:nirai_shared/nirai_theme.dart';
import 'package:nirai_shared/portal_scope.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:nirai_client/portal.dart' as client;
import 'package:nirai_vendor/portal.dart' as vendor;

import 'landing/landing_screen.dart';
import 'landing/portal_choice_screen.dart';
import 'portal_host.dart';

const _prefsKeyDefaultRole = 'nirai.defaultRole';
const _prefsKeyHasDefaultRole = 'nirai.hasDefaultRole';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  final hasDefault = prefs.getBool(_prefsKeyHasDefaultRole) ?? false;
  final saved = prefs.getString(_prefsKeyDefaultRole);
  final savedRole = saved == 'vendor' ? PortalRole.vendor : PortalRole.client;

  runApp(NiraiApp(defaultRole: savedRole, hasDefaultRole: hasDefault, prefs: prefs));
}

class NiraiApp extends StatefulWidget {
  const NiraiApp({super.key, required this.defaultRole, required this.hasDefaultRole, required this.prefs});

  final PortalRole defaultRole;
  final bool hasDefaultRole;
  final SharedPreferences prefs;

  @override
  State<NiraiApp> createState() => _NiraiAppState();
}

class _NiraiAppState extends State<NiraiApp> {
  late final PortalController _portal = PortalController(role: widget.defaultRole);
  late final client.AppState _clientState = client.AppState.seeded();
  late final vendor.AppState _vendorState = vendor.AppState();
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  late bool _hasDefaultRole = widget.hasDefaultRole;
  late PortalRole _lastRole = _portal.role;
  late PortalRole _lastPersistedDefaultRole = _portal.defaultRole;
  bool _pendingPortalNavReset = false;

  @override
  void initState() {
    super.initState();
    _portal.addListener(_persistDefault);
    _portal.addListener(_handlePortalChange);
  }

  void _handlePortalChange() {
    final nextRole = _portal.role;
    if (nextRole == _lastRole) {
      // Default role changes still need to repaint Settings.
      if (mounted) setState(() {});
      return;
    }

    _lastRole = nextRole;
    if (!mounted) return;
    setState(() {
      // Ensure we clear any back stack from the previous portal.
      _pendingPortalNavReset = true;
    });
  }

  void _persistDefault() {
    // Persist ONLY when defaultRole actually changes (i.e., user explicitly set it).
    if (_portal.defaultRole == _lastPersistedDefaultRole) return;
    _lastPersistedDefaultRole = _portal.defaultRole;

    final v = _portal.defaultRole == PortalRole.vendor ? 'vendor' : 'client';
    widget.prefs.setBool(_prefsKeyHasDefaultRole, true);
    widget.prefs.setString(_prefsKeyDefaultRole, v);

    if (!_hasDefaultRole && mounted) {
      setState(() => _hasDefaultRole = true);
    }
  }

  @override
  void dispose() {
    _portal.removeListener(_persistDefault);
    _portal.removeListener(_handlePortalChange);
    _portal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final postLanding = _hasDefaultRole ? const PortalHost() : const PortalChoiceScreen();

    Widget app = MaterialApp(
      navigatorKey: _navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: NiraiTheme.theme(),
      home: LandingScreen(next: postLanding),
    );

    // Critical: scopes must be ABOVE MaterialApp so pushed routes can read state.
    // Keep BOTH scopes mounted so portal switching can't crash mid-frame.
    app = vendor.AppStateScope(state: _vendorState, child: app);
    app = client.AppStateScope(notifier: _clientState, child: app);

    if (_pendingPortalNavReset) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute<void>(builder: (_) => const PortalHost()),
          (r) => false,
        );
        if (!mounted) return;
        setState(() => _pendingPortalNavReset = false);
      });
    }

    return PortalScope(
      controller: _portal,
      child: app,
    );
  }
}
