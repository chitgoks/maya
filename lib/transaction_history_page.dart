import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:maya/login_page.dart';

class TransactionHistoryPage extends StatefulWidget {
  final http.Client httpClient;

  const TransactionHistoryPage(this.httpClient, { super.key });

  @override
  TransactionHistoryPageState createState() => TransactionHistoryPageState();
}

class TransactionHistoryPageState extends State<TransactionHistoryPage> {

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('transactions');
              setState(() {});
            },
          ),
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
      body: FutureBuilder<List<String>>(
        future: _getTransactions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error loading transactions'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No transactions found'),
            );
          } else {
            final transactions = snapshot.data!;
            return ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Sent ${transactions[index]}'),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<String>> _getTransactions() async {
    await widget.httpClient.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('transactions') ?? [];
  }
}
