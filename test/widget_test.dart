// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vehicle_service_book_app/main.dart';

void main() {
  testWidgets('App should render welcome page', (WidgetTester tester) async {
    await tester.pumpWidget(const VehicleServiceBookApp());

    expect(find.text('Clean'), findsOneWidget);
    expect(find.byType(Image), findsWidgets);
  });
}
