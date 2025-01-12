import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:maya/login_page.dart';

class SendMoneyPage extends StatefulWidget {
  final http.Client httpClient;

  const SendMoneyPage(this.httpClient, {super.key});

  @override
  SendMoneyPageState createState() => SendMoneyPageState();
}

class SendMoneyPageState extends State<SendMoneyPage> {
  final TextEditingController _amountController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Money'),
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
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: () async {
                setState(() {
                  _isLoading = true;
                });

                final amount = double.tryParse(_amountController.text);
                if (amount != null && amount > 0) {
                  final response = await widget.httpClient.post(
                    Uri.parse('https://jsonplaceholder.typicode.com/posts'),
                    headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                    },
                    body: jsonEncode(<String, String>{
                      'amount': _amountController.text,
                    }),
                  );

                  if (response.statusCode == 201) {
                    final prefs = await SharedPreferences.getInstance();
                    List<String>? transactions = prefs.getStringList('transactions') ?? [];

                    transactions.add(_amountController.text);
                    await prefs.setStringList('transactions', transactions);

                    _amountController.text = '';
                    _showBottomSheet('Success', 'Money sent.');
                  } else {
                    _showBottomSheet('Error', 'Failed to send money.');
                  }
                } else {
                  _showBottomSheet('Error', 'Invalid amount.');
                }

                setState(() {
                  _isLoading = false;
                });
              },
              child: const Text('Send Money'),
            ),
          ],
        ),
      ),
    );
  }

  void _showBottomSheet(String title, String message) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text(message),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }
}
