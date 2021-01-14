import 'package:hive/hive.dart';

part 'account.g.dart';

@HiveType(typeId: 1)
class AccountModel{
  @HiveField(0)
  int id;
  @HiveField(1)
  String acc_name;
  @HiveField(2)
  String acc_no;
  @HiveField(3)
  String acc_bank;
  @HiveField(4)
  int project;
  @HiveField(5)
  String bank_code;

  AccountModel({ this.id, this.acc_name, this.acc_no, this.acc_bank, this.project });
}