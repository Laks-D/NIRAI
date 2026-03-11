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
  runApp(NiraiClientApp(prefs: prefs, state: state));
}

class NiraiClientApp extends StatefulWidget {
  const NiraiClientApp({super.key, required this.prefs, required this.state});

  final SharedPreferences prefs;
  final AppState state;

  @override
  State<NiraiClientApp> createState() => _NiraiClientAppState();
}

class _NiraiClientAppState extends State<NiraiClientApp> {
  late final AppState _state = widget.state;
  late final AppStatePersistence _persistence = AppStatePersistence.bind(prefs: widget.prefs, state: _state);

  @override
  void dispose() {
    _persistence.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppPersistenceScope(
      persistence: _persistence,
      child: AppStateScope(
        notifier: _state,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: NiraiTheme.theme(),
          home: const AppShell(),
        ),
      ),
    );
  }
}
