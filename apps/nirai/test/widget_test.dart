// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:nirai_shared/portal_scope.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:nirai/main.dart';

void main() {
  testWidgets('Nirai boots to client onboarding by default', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(NiraiApp(defaultRole: PortalRole.client, hasDefaultRole: false, prefs: prefs));

    // Landing first.
    expect(find.text('NIRAI'), findsOneWidget);

    // Then onboarding (after landing completes).
    await tester.pump(const Duration(milliseconds: 1400));
    await tester.pumpAndSettle();
    expect(find.text('Choose portal'), findsOneWidget);
  });
}
