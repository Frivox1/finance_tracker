import 'package:hive/hive.dart';
import 'package:finance_tracker/models/account.dart';

class Boxes {
  static Box<Account> getAccounts() => Hive.box<Account>('accountBox');
}
