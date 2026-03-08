import 'package:flutter/material.dart';
import 'package:nirai_shared/nirai_theme.dart';

import 'src/app/app_shell.dart';
import 'src/app/app_state.dart';

void main() {
  runApp(const NiraiVendorApp());
}

class NiraiVendorApp extends StatefulWidget {
  const NiraiVendorApp({super.key});

  @override
  State<NiraiVendorApp> createState() => _NiraiVendorAppState();
}

class _NiraiVendorAppState extends State<NiraiVendorApp> {
  final AppState _state = AppState();

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppStateScope(
      state: _state,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: NiraiTheme.theme(),
        home: const AppShell(),
      ),
    );
  }
}
