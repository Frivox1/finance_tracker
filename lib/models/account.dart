import 'package:hive/hive.dart';

part 'account.g.dart';

@HiveType(typeId: 0)
class Account extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String category;

  @HiveField(2)
  double balance;

  Account({required this.name, required this.category, required this.balance});
}
