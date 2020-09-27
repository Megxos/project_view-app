import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class UserModel{
  @HiveField(0)
  int user_id;
  @HiveField(1)
  String firstname;
  @HiveField(2)
  String lastname;
  @HiveField(3)
  String email;

  UserModel({ this.user_id, this.email, this.firstname, this.lastname });
}