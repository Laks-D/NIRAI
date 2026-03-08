import 'package:flutter/material.dart';
import 'package:nirai_shared/nirai_theme.dart';

import 'src/app/app_shell.dart';
import 'src/app/app_state.dart';

void main() {
  runApp(const NiraiClientApp());
}

class NiraiClientApp extends StatefulWidget {
  const NiraiClientApp({super.key});

  @override
  State<NiraiClientApp> createState() => _NiraiClientAppState();
}

class _NiraiClientAppState extends State<NiraiClientApp> {
  late final AppState _state = AppState.seeded();

  @override
  Widget build(BuildContext context) {
    return AppStateScope(
      notifier: _state,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: NiraiTheme.theme(),
        home: const AppShell(),
      ),
    );
  }
}
