import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:maya/login_page.dart';
import 'package:maya/send_money_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late MockClient mockHttpClient;

  setUpAll(() {
    SharedPreferences.setMockInitialValues({});

    mockHttpClient = MockClient((request) async {
      await Future.delayed(const Duration(seconds: 1));
      return http.Response(jsonEncode({}), 201);
    });
  });

  testWidgets('[SendMoneyPage] display bottom sheet after posting to API and close.', (WidgetTester tester) async {
    // Given
    await tester.pumpWidget(MaterialApp(home: SendMoneyPage(mockHttpClient)));
    await tester.enterText(find.byType(TextField), '100');

    // When
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Then
    // Ensure loading indicator is visible.
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();

    // Check if modal bottom sheet is shown.
    expect(find.text('Success'), findsOneWidget);
    expect(find.text('Money sent.'), findsOneWidget);

    // Close the BottomSheet.
    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();

    // Verify BottomSheet is dismissed.
    expect(find.text('Success'), findsNothing);
  });

  testWidgets('[SendMoneyPage] tap logout button and redirect to login page.', (WidgetTester tester) async {
    // Given
    await tester.pumpWidget(MaterialApp(home: SendMoneyPage(mockHttpClient)));

    // When
    await tester.tap(find.byIcon(Icons.logout));
    await tester.pumpAndSettle();

    // Then
    expect(find.byType(LoginPage), findsOneWidget);
  });
}