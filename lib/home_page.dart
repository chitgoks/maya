import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maya/login_page.dart';
import 'package:maya/send_money_page.dart';
import 'package:maya/transaction_history_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({ super.key });

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  bool _isBalanceVisible = false;
  final double _balance = 500;

  void _toggleBalanceVisibility() {
    setState(() {
      _isBalanceVisible = !_isBalanceVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage(http.Client())),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Wallet Balance:'),
                Row(
                  children: [
                    Text(_isBalanceVisible ? '$_balance php' : '******'),
                    IconButton(
                      icon: Icon(_isBalanceVisible ? Icons.visibility : Icons.visibility_off),
                      onPressed: _toggleBalanceVisibility,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Card(
                    elevation: 8.0,
                    child: ListTile(
                      dense: true,
                      minVerticalPadding: 16,
                      horizontalTitleGap: 4,
                      leading: const Icon(Icons.send),
                      title: const Text('Send Money', textAlign: TextAlign.center),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SendMoneyPage(http.Client())),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Card(
                    elevation: 8.0,
                    child: ListTile(
                      dense: true,
                      minVerticalPadding: 16,
                      horizontalTitleGap: 4,
                      leading: const Icon(Icons.history),
                      title: const Text('Transactions', textAlign: TextAlign.center),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TransactionHistoryPage(http.Client())),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
