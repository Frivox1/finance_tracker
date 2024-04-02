import 'package:flutter/material.dart';
import 'package:finance_tracker/screens/new_account_screen.dart';
import 'package:finance_tracker/screens/list_account_screen.dart'; // Import corrected list of accounts screen

class SidebarMenu extends StatelessWidget {
  // ignore: use_super_parameters
  const SidebarMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            child: Text(
              'Finance Tracker',
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
          ),
          ListTile(
            title: const Text(
              'New account',
              style: TextStyle(fontSize: 24),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NewAccountScreen(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text(
              'List of accounts',
              style: TextStyle(fontSize: 24),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ListOfAccountsScreen(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text(
              'Settings',
              style: TextStyle(fontSize: 24),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
