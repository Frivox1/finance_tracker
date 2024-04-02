import 'package:flutter/material.dart';
import 'package:finance_tracker/widgets/sidebar_menu.dart';
// ignore: unused_import
import 'package:hive/hive.dart';
import 'package:finance_tracker/models/account.dart';
import 'package:finance_tracker/boxes.dart';

class HomePage extends StatelessWidget {
  // ignore: use_super_parameters
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Finance Tracker',
          style: TextStyle(fontSize: 28),
        ),
      ),
      drawer: const SidebarMenu(),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Hi, [name]', // Replace [name] with the actual name
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20), // Add spacing between the texts
            const Text(
              'Your current balance:',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 10),
            FutureBuilder<double>(
              future: _getTotalBalance(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                final totalBalance = snapshot.data;
                return Text(
                  '${totalBalance?.toStringAsFixed(2) ?? '0.00'}€', // Display balance with 2 decimal places
                  style: const TextStyle(
                      fontSize: 44, fontWeight: FontWeight.bold),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 10.0,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        onPressed: () => {},
        label: const Text('+ Add transaction'),
      ),
    );
  }

  Future<double> _getTotalBalance() async {
    final box = Boxes.getAccounts();
    if (box.isEmpty) {
      return 0.0;
    }

    final List<Account> accounts = box.values.toList();
    double totalBalance = 0;
    for (var account in accounts) {
      totalBalance += account.balance;
    }
    return totalBalance;
  }
}
