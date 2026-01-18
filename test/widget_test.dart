// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:reminder_app/main.dart';
import 'package:reminder_app/data/reminder_repository.dart';
import 'package:reminder_app/services/notification_service.dart';

void main() {
  testWidgets('Home screen renders', (WidgetTester tester) async {
    final repository = ReminderRepository(
      notificationService: NotificationService.instance,
    );
    await tester.pumpWidget(ReminderApp(repository: repository));
    expect(find.text('Reminder App'), findsOneWidget);
  });
}
