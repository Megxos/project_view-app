import 'package:hive/hive.dart';

part 'account.g.dart';

@HiveType(typeId: 1)
class AccountModel {
  @HiveField(0)
  int id;
  @HiveField(1)
  String accName;
  @HiveField(2)
  String accNo;
  @HiveField(3)
  String accBank;
  @HiveField(4)
  int project;
  @HiveField(5)
  String bankCode;

  AccountModel({this.id, this.accName, this.accNo, this.accBank, this.project});
}
