import 'package:flutter/material.dart';
import 'package:nirai_shared/nirai_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/app/app_shell.dart';
import 'src/app/app_state.dart';
import 'src/app/app_state_persistence.dart';
import 'src/app/app_persistence_scope.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final state = await AppStatePersistence.load(prefs);
  runApp(NiraiVendorApp(prefs: prefs, state: state));
}

class NiraiVendorApp extends StatefulWidget {
  const NiraiVendorApp({super.key, required this.prefs, required this.state});

  final SharedPreferences prefs;
  final AppState state;

  @override
  State<NiraiVendorApp> createState() => _NiraiVendorAppState();
}

class _NiraiVendorAppState extends State<NiraiVendorApp> {
  late final AppState _state = widget.state;
  late final AppStatePersistence _persistence = AppStatePersistence.bind(prefs: widget.prefs, state: _state);

  @override
  void dispose() {
    _persistence.dispose();
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppPersistenceScope(
      persistence: _persistence,
      child: AppStateScope(
        state: _state,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: NiraiTheme.theme(),
          home: const AppShell(),
        ),
      ),
    );
  }
}
