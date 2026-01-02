import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// Note: Ensure the package name 'medtrack' matches your actual project name in pubspec.yaml
import 'package:medtrack/main.dart';

void main() {
  testWidgets('Counter increment smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // CHANGED: Use MedTrackApp() instead of MyApp()
    await tester.pumpWidget(const MedTrackApp());

    // Verify that our landing screen text is present (adjust based on your actual UI)
    expect(find.text('MedTrack'), findsOneWidget);
    expect(find.text('Doctor Portal'), findsOneWidget);
  });
}
