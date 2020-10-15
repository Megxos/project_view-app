import 'package:hive/hive.dart';
part 'current_project.g.dart';

CurrentProject currentProjectModel = CurrentProject();

@HiveType(typeId: 5)
class CurrentProject{
  @HiveField(0)
  int id;
  @HiveField(1)
  String name;
  @HiveField(2)
  int code;
  @HiveField(3)
  int owner;

  CurrentProject({ this.id, this.name, this.owner, this.code });


  add(CurrentProject project)async{
    final currentProjectBox = Hive.box<CurrentProject>("current_project");
    currentProjectBox.add(project);
  }
}