import 'package:flutter/widgets.dart';
import 'package:nirai_shared/portal_scope.dart';

import 'package:nirai_client/portal.dart' as client;
import 'package:nirai_vendor/portal.dart' as vendor;

class PortalHost extends StatelessWidget {
  const PortalHost({super.key});

  @override
  Widget build(BuildContext context) {
    final role = PortalScope.of(context).role;
    return role == PortalRole.vendor ? const vendor.AppShell() : const client.AppShell();
  }
}
