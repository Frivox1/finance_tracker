import 'package:flutter/material.dart';
import 'package:finance_tracker/widgets/sidebar_menu.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:finance_tracker/models/account.dart';
import 'package:finance_tracker/boxes.dart';
import 'package:finance_tracker/screens/new_transaction.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Account> accounts = []; // Initialize accounts as an empty list

  @override
  void initState() {
    super.initState();
    _initializeBoxes();
  }

  void _initializeBoxes() async {
    final accountsBox = await Boxes.getAccounts();
    setState(() {
      accounts = accountsBox.values.toList();
    });
  }

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
            const SizedBox(height: 20),
            const Text(
              'Your current balance:',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 10),
            Text(
              '${_getTotalBalance().toStringAsFixed(2)}€',
              style: const TextStyle(fontSize: 44, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 10.0,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const NewTransaction())),
        label: const Text('+ Add transaction'),
      ),
    );
  }

  double _getTotalBalance() {
    double totalBalance = 0;
    for (var account in accounts) {
      totalBalance += account.balance;
    }
    return totalBalance;
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}
