import 'package:flutter_test/flutter_test.dart';
import 'package:ai_health_assistant/main.dart';

void main() {
  testWidgets('AI Health Assistant app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const AIHealthAssistantApp());
    await tester.pumpAndSettle();

    // Verify login screen elements appear
    expect(find.text('AI Health Assistant'), findsWidgets);
    expect(find.text('Sign In'), findsWidgets);
  });
}
