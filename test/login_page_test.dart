import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maya/login_page.dart';
import 'package:maya/home_page.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'dart:convert';

void main() {
  late MockClient mockHttpClient;

  setUpAll(() async {
    mockHttpClient = MockClient((request) async {
      // Delay to simulate some time logging in so progress indicator
      // will be visible.
      await Future.delayed(const Duration(seconds: 1));
      return http.Response(jsonEncode({}), 201);
    });
  });

  testWidgets('[LoginPage] display loading widget when logging in and redirect to home page.', (WidgetTester tester) async {
    // Given
    await tester.pumpWidget(MaterialApp(home: LoginPage(mockHttpClient)));
    await tester.enterText(find.byType(TextField).at(0), 'h');
    await tester.enterText(find.byType(TextField).at(1), 'h');

    // When
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Then
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.byType(HomePage), findsOneWidget);
  });
}
