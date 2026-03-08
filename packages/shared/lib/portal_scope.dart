import 'package:flutter/widgets.dart';

enum PortalRole {
  client,
  vendor,
}

class PortalController extends ChangeNotifier {
  PortalController({PortalRole role = PortalRole.client, PortalRole? defaultRole})
      : _role = role,
        _defaultRole = defaultRole ?? role;

  PortalRole _role;
  PortalRole _defaultRole;

  PortalRole get role => _role;
  PortalRole get defaultRole => _defaultRole;

  void setRole(PortalRole next) {
    if (_role == next) return;
    _role = next;
    notifyListeners();
  }

  void setDefaultRole(PortalRole next) {
    if (_defaultRole == next) return;
    _defaultRole = next;
    notifyListeners();
  }
}

class PortalScope extends InheritedNotifier<PortalController> {
  const PortalScope({super.key, required PortalController controller, required Widget child})
      : super(notifier: controller, child: child);

  static PortalController? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<PortalScope>()?.notifier;
  }

  static PortalController of(BuildContext context) {
    final controller = maybeOf(context);
    assert(controller != null, 'No PortalScope found in context');
    return controller!;
  }
}
