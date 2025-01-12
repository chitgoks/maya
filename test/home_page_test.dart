import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maya/home_page.dart';
import 'package:maya/login_page.dart';
import 'package:maya/send_money_page.dart';
import 'package:maya/transaction_history_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {

  testWidgets('[HomePage] displays wallet balance and toggle visibility to show amount.', (WidgetTester tester) async {
    // Given
    await tester.pumpWidget(const MaterialApp(home: HomePage()));

    // When
    await tester.tap(find.byIcon(Icons.visibility_off));
    await tester.pump();

    // Then
    expect(find.textContaining('500'), findsOneWidget);
    expect(find.text('*'), findsNothing);
  });

  testWidgets('[HomePage] navigates to SendMoneyPage on tap.', (WidgetTester tester) async {
    // Given
    await tester.pumpWidget(const MaterialApp(home: HomePage()));

    // When
    await tester.tap(find.text('Send Money'));
    await tester.pumpAndSettle();

    // Then
    expect(find.byType(SendMoneyPage), findsOneWidget);
  });

  testWidgets('[HomePage] navigates to TransactionHistoryPage on tap.', (WidgetTester tester) async {
    // Given
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const MaterialApp(home: HomePage()));

    // When
    await tester.tap(find.text('Transactions'));
    await tester.pumpAndSettle();

    // Then
    expect(find.byType(TransactionHistoryPage), findsOneWidget);
  });

  testWidgets('[HomePage] tap logout button and redirect to login page.', (WidgetTester tester) async {
    // Given
    await tester.pumpWidget(const MaterialApp(home: HomePage()));

    // When
    await tester.tap(find.byIcon(Icons.logout));
    await tester.pumpAndSettle();

    // Then
    expect(find.byType(LoginPage), findsOneWidget);
  });
}
