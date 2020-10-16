import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:project_view/controllers/item.controller.dart';
import 'package:project_view/models/current_project.dart';
import 'package:project_view/models/project.dart';
import 'package:project_view/services/project.dart';
import 'package:project_view/ui/progress_indicator.dart';
import 'package:project_view/ui/colors.dart';

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
    CurrentProject currentProject = currentProjectBox.get(0);
    if( currentProject != null){
      setState(() {
        dropDownText = "${currentProject.name} (${currentProject.code})";
      });
    }
  }

  updateCurrentProject(CurrentProject project)async{
    progressIndicator.Loading(text: "Please wait", context: context);

    currentProjectModel.addProject(project);

    int statusCode = await item.getItems(currentProjectBox.get(0).code);

    Navigator.pop(context);
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
              SizedBox(width: 50,),
              Expanded(
                child: DropdownButtonHideUnderline(
                child: DropdownButton<Project>(
                  isDense: true,
                  iconSize: 35,
                  isExpanded: true,
                  elevation: 0,
                  style: TextStyle().copyWith(color: plainWhite, fontSize: 18, fontFamily: "SFProText"),
                  dropdownColor: secondaryColor,
                  icon: Icon(Icons.keyboard_arrow_down, color: Colors.white,),
                  hint: Align(
                    child: Text(dropDownText,
                        style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)
                    ),
                    alignment: Alignment.centerRight,
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
                      child: ListTile(
                        title: Text("${project.name} (${project.code})", style: TextStyle().copyWith(color: plainWhite, fontSize: 20.0),),
                        trailing: PopupMenuButton(
                          color: plainWhite,
                          itemBuilder: (context)=>[
                            PopupMenuItem(
                                child: FlatButton.icon(
                                    icon: Icon(Icons.delete, color: red,),
                                    label: Text("Delete project"),
                                    onPressed: (){}
                                    )
                            ),
                            PopupMenuItem(
                                child: FlatButton.icon(
                                    icon: Icon(Icons.content_copy, color: secondaryColor,),
                                    label: Text("Copy code"),
                                    onPressed: (){}
                                )
                            )
                          ],
                        )
                      ),
                      )
                  ).toList(),
                ),
                  ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
