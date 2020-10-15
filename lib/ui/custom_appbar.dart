import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:project_view/models/current_project.dart';
import 'package:project_view/models/project.dart';
import 'package:project_view/services/project.dart';

class CustomAppBar extends StatefulWidget {
  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}
List<Project> projects = [

];

newProject(Project project){
  projects.add(project);
  _CustomAppBarState().reassemble();
}


class _CustomAppBarState extends State<CustomAppBar> {

  final projectBox = Hive.box<ProjectModel>("project");

  final currentProjectBox = Hive.box<CurrentProject>("current_project");

  String dropDownText = "Project";

  void currentProject(){
    print(currentProjectBox.get(0));
    CurrentProject currentProject = currentProjectBox.get(0);
    if( currentProject != null){
      setState(() {
        dropDownText = currentProject.name;
      });
    }
  }

  updateCurrentProject(CurrentProject project){
    currentProjectBox.clear();
    currentProjectModel.add(project);
  }

  final _containerKey = GlobalKey();

  // Project currentProject;

  @override
  Widget build(BuildContext context) {
    projects.clear();
    currentProject();
    for(int i = 0; i < projectBox.length; i++){
      setState(() {
        projects.add(Project(
            name: projectBox.get(i).name,
            isCompleted: false,
            owner: projectBox.get(i).owner,
          id: projectBox.get(i).id,
          code: projectBox.get(i).code
        ));
      });
    }

    return Container(
      height: 90.0,
      key: _containerKey,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.indigo[500], Colors.blue])
      ),
      child: SafeArea(
        child: Container(
          // padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.menu, color: Colors.white,),
                onPressed: (){
                  Scaffold.of(context).openDrawer();
                },
              ),
              DropdownButtonHideUnderline(
              child: DropdownButton<Project>(
                isDense: true,
                iconSize: 35,
                icon: Icon(Icons.keyboard_arrow_down, color: Colors.white,),
                hint: Text(dropDownText,
                    style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)
                ),
                onChanged: (Project project) {
                  setState(() {
                    dropDownText = project.name;
                    updateCurrentProject(CurrentProject(
                      id: project.id,
                      code: project.code,
                      owner: project.owner,
                      name: project.name
                    ));
                  });
                },
                items: projects
                    .map((project) => DropdownMenuItem(
                    value: project,
                    child: Text(
                      project.name,
                    )))
                    .toList(),
              ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
