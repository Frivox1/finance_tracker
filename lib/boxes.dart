import 'package:hive/hive.dart';
import 'package:finance_tracker/models/account.dart';

class Boxes {
  static Future<Box<Account>> getAccounts() async {
    await Hive.openBox<Account>('accountBox');
    return Hive.box<Account>('accountBox');
  }
}
