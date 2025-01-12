import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maya/transaction_history_page.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late MockClient mockHttpClient;

  setUpAll(() {
    mockHttpClient = MockClient((request) async {
      await Future.delayed(const Duration(seconds: 1));
      return http.Response('[]', 200);
    });
  });

  testWidgets('[TransactionHistoryPage] display loading widget and show history entries.', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({'transactions': ['100', '200', '300']});

    await tester.pumpWidget(MaterialApp(home: TransactionHistoryPage(mockHttpClient)));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();

    expect(find.byType(ListTile), findsWidgets);
    expect(find.descendant(of: find.byType(ListView), matching: find.byType(ListTile)).evaluate().length, 3);
  });
}