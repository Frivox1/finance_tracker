import 'package:flutter/material.dart';
import 'package:finance_tracker/models/account.dart';
import 'package:finance_tracker/boxes.dart';
import 'package:hive_flutter/hive_flutter.dart';

class NewTransaction extends StatefulWidget {
  const NewTransaction({Key? key}) : super(key: key);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  late String _selectedAccount;
  late TextEditingController _amountController;
  late Future<Box<Account>> _accountsFuture; // Future for accounts
  bool _isAddTransaction = true; // Flag to indicate add or deduct transaction

  @override
  void initState() {
    super.initState();
    _selectedAccount = ''; // Initialize the selected account to empty
    _amountController = TextEditingController();
    _accountsFuture = _getAccounts(); // Initialize the future
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Transaction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<Box<Account>>(
                future: _accountsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  final box = snapshot.data!;
                  final List<Account> accounts = box.values.toList();
                  if (accounts.isEmpty) {
                    return Text(
                      'Create first an account',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }
                  if (!_selectedAccount.isNotEmpty ||
                      !accounts
                          .any((account) => account.name == _selectedAccount)) {
                    // If _selectedAccount is empty or doesn't match any account name, set it to the first account name
                    _selectedAccount =
                        accounts.isNotEmpty ? accounts.first.name : '';
                  }
                  return Column(
                    children: [
                      DropdownButtonFormField<String>(
                        value: _selectedAccount,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedAccount = newValue!;
                          });
                        },
                        items: accounts.map((Account account) {
                          return DropdownMenuItem<String>(
                            value: account.name,
                            child: Text(account.name),
                          );
                        }).toList(),
                        decoration: InputDecoration(labelText: 'Account'),
                      ),
                      Row(
                        children: [
                          Radio(
                            value: true,
                            groupValue: _isAddTransaction,
                            onChanged: (value) {
                              setState(() {
                                _isAddTransaction = value as bool;
                              });
                            },
                          ),
                          Text('Add transaction'),
                          Radio(
                            value: false,
                            groupValue: _isAddTransaction,
                            onChanged: (value) {
                              setState(() {
                                _isAddTransaction = value as bool;
                              });
                            },
                          ),
                          Text('Deduct transaction'),
                        ],
                      ),
                    ],
                  );
                },
              ),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: 'Amount'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _processTransaction,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Box<Account>> _getAccounts() async {
    return Boxes.getAccounts();
  }

  void _processTransaction() {
    final double amount = double.tryParse(_amountController.text) ?? 0.0;
    if (amount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid amount'),
        ),
      );
      return;
    }
    final Future<Box<Account>> boxFuture = _getAccounts();
    boxFuture.then((box) {
      final Account? selectedAccount = box.values.firstWhere(
        (account) => account.name == _selectedAccount,
      );
      if (selectedAccount == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Selected account not found'),
          ),
        );
        return;
      }
      if (!_isAddTransaction && selectedAccount.balance < amount) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Insufficient balance'),
          ),
        );
        return;
      }
      if (_isAddTransaction) {
        selectedAccount.balance += amount;
      } else {
        selectedAccount.balance -= amount;
      }
      selectedAccount.save();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Transaction processed for $_selectedAccount'),
        ),
      );
      _amountController.clear();
    });
  }
}
