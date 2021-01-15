import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:project_view/controllers/item.controller.dart';
part 'current_project.g.dart';

CurrentProject currentProjectModel = CurrentProject();

@HiveType(typeId: 5)
class CurrentProject {
  @HiveField(0)
  int id;
  @HiveField(1)
  String name;
  @HiveField(2)
  int code;
  @HiveField(3)
  int owner;

  CurrentProject({this.id, this.name, this.owner, this.code});

  addProject(CurrentProject project, BuildContext context) async {
    final currentProjectBox = Hive.box<CurrentProject>("current_project");

    currentProjectBox.put(0, project);
    await item.getItems(currentProjectBox.get(0).code, context);
  }
}
