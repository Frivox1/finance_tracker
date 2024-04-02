import 'package:flutter/material.dart';
import 'package:finance_tracker/screens/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:finance_tracker/models/account.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register adapters
  Hive.registerAdapter(AccountAdapter());

  try {
    // Open the box for accounts
    await Hive.openBox<Account>('accountBox');

    runApp(const FinanceTracker());
  } catch (e) {
    // ignore: avoid_print
    print('Error opening Hive box: $e');
  }
}

class FinanceTracker extends StatelessWidget {
  // ignore: use_super_parameters
  const FinanceTracker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Finance Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
