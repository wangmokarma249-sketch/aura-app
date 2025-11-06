import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:aura/main.dart';

void main() {
  testWidgets('Aura app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const AuraApp());

    expect(find.text('WELCOME TO AURA'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
  });
}
