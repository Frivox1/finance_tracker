import 'package:flutter/material.dart';
import 'package:finance_tracker/models/account.dart';
import 'package:hive/hive.dart';
import 'package:finance_tracker/boxes.dart';

class NewAccountScreen extends StatefulWidget {
  // ignore: use_super_parameters
  const NewAccountScreen({Key? key}) : super(key: key);

  @override
  State<NewAccountScreen> createState() => _NewAccountScreenState();
}

class _NewAccountScreenState extends State<NewAccountScreen> {
  final TextEditingController nameController = TextEditingController();
  String selectedCategory = 'Cash'; // Default category
  late TextEditingController balanceController;

  @override
  void initState() {
    super.initState();
    balanceController = TextEditingController(); // Initialize in initState
  }

  @override
  void dispose() {
    Hive.close();
    nameController.dispose(); // Dispose of text controllers
    balanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New Account',
          style: TextStyle(fontSize: 30),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: nameController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Name of the account',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 5),
              SizedBox(
                width: 300,
                child: DropdownButtonFormField<String>(
                  value: selectedCategory,
                  items: const ['Cash', 'Digital', 'Investing']
                      .map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value!;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Select category',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 5),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: balanceController, // Add controller for balance
                  decoration: const InputDecoration(
                    hintText: 'Current balance on the account',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 60),
              SizedBox(
                width: 300,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    // Check if balance is not empty before parsing
                    if (balanceController.text.isNotEmpty) {
                      addAccount(
                        nameController.text,
                        selectedCategory,
                        double.parse(balanceController.text),
                      );
                      Navigator.pop(context);
                      FocusScope.of(context).unfocus(); // Close keyboard
                    } else {
                      // Show an error message or handle the empty balance
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    textStyle: MaterialStateProperty.all<TextStyle>(
                      const TextStyle(fontSize: 20),
                    ),
                  ),
                  child: const Text('Add account'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addAccount(String name, String category, double balance) async {
    final account = Account(name: name, category: category, balance: balance);
    final box = await Boxes
        .getAccounts(); // Await to get the actual Box<Account> object
    box.add(account);
  }
}
