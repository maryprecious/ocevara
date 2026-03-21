import 'package:flutter_test/flutter_test.dart';
import 'package:ocevara/main.dart';
import 'package:ocevara/features/onboarding/screens/splash-screen.dart';

void main() {
  testWidgets('App starts with Splash Screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const OcevaraApp());

    // Verify that Splash Screen is present.
    expect(find.byType(SplashScreen), findsOneWidget);
  });
}

