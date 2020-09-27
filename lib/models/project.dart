import 'package:hive/hive.dart';

part 'project.g.dart';

@HiveType(typeId: 3)
class ProjectModel{
  @HiveField(0)
  int id;
  @HiveField(1)
  String name;
  @HiveField(2)
  int code;
  @HiveField(3)
  int owner;

  ProjectModel({ this.id, this.name, this.owner, this.code });
}