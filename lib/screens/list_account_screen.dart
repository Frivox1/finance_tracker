import 'package:flutter/material.dart';
import 'package:finance_tracker/models/account.dart';
import 'package:hive/hive.dart';
import 'package:finance_tracker/screens/new_account_screen.dart';

class ListOfAccountsScreen extends StatefulWidget {
  // ignore: use_super_parameters
  const ListOfAccountsScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ListOfAccountsScreenState createState() => _ListOfAccountsScreenState();
}

class _ListOfAccountsScreenState extends State<ListOfAccountsScreen> {
  late List<Account> accounts;

  @override
  void initState() {
    super.initState();
    fetchAccounts();
  }

  Future<void> fetchAccounts() async {
    final box = await Hive.openBox<Account>('accountBox');
    setState(() {
      accounts = box.values.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'List of Accounts',
          style: TextStyle(fontSize: 30),
        ),
      ),
      body: accounts.isEmpty
          ? const Center(
              child: Text(
                'No accounts available',
                style: TextStyle(fontSize: 20),
              ),
            )
          : DataTable(
              columns: const <DataColumn>[
                DataColumn(
                  label: Expanded(
                    child: Text(
                      'Name',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                DataColumn(
                  label: Expanded(
                    child: Text(
                      'Type',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                DataColumn(
                  label: Expanded(
                    child: Text(
                      'Balance',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                DataColumn(
                  label: SizedBox(), // Empty space for the delete icon column
                ),
              ],
              rows: accounts.map((account) {
                return DataRow(
                  cells: <DataCell>[
                    DataCell(Text(account.name)),
                    DataCell(Text(account.category)),
                    DataCell(Text(account.balance.toString())),
                    DataCell(
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _confirmDeleteAccount(context, account);
                        },
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 10.0,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const NewAccountScreen())),
        label: const Text('+ Add Account'),
      ),
    );
  }

  Future<void> _confirmDeleteAccount(
      BuildContext context, Account account) async {
    final bool deleteConfirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete ${account.name}?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancel deletion
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirm deletion
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );

    if (deleteConfirmed) {
      _deleteAccount(account);
    }
  }

  Future<void> _deleteAccount(Account account) async {
    final box = await Hive.openBox<Account>('accountBox');
    await box.delete(account.key);
    fetchAccounts(); // Refresh the list after deletion
  }
}
