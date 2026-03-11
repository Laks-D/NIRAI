// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:nirai_vendor/main.dart';
import 'package:nirai_vendor/src/app/app_state_persistence.dart';

void main() {
  testWidgets('Vendor app boots to onboarding', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final state = await AppStatePersistence.load(prefs);

    await tester.pumpWidget(NiraiVendorApp(prefs: prefs, state: state));

    // Splash first.
    expect(find.text('Nirai Vendor'), findsOneWidget);

    // Then auto-navigates to onboarding.
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();
    expect(find.text('Battery-first tracking'), findsOneWidget);
  });
}
