import 'package:flutter/widgets.dart';

import 'app_state_persistence.dart';

class AppPersistenceScope extends InheritedWidget {
  const AppPersistenceScope({super.key, required this.persistence, required super.child});

  final AppStatePersistence persistence;

  static AppStatePersistence? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppPersistenceScope>()?.persistence;
  }

  static AppStatePersistence of(BuildContext context) {
    final p = maybeOf(context);
    assert(p != null, 'No AppPersistenceScope found in context');
    return p!;
  }

  @override
  bool updateShouldNotify(AppPersistenceScope oldWidget) => false;
}
