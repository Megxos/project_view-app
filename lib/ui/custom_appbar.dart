import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:project_view/models/current_project.dart';
import 'package:project_view/models/project.dart';
import 'package:project_view/ui/custom_alerts.dart';
import 'package:project_view/ui/progress_indicator.dart';
import 'package:project_view/ui/colors.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:project_view/controllers/project.controller.dart';
import 'package:share/share.dart';

class CustomAppBar extends StatefulWidget {
  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  final projectBox = Hive.box<ProjectModel>("project");

  final currentProjectBox = Hive.box<CurrentProject>("current_project");

  CurrentProject _defaultProject =
      CurrentProject(id: 0, owner: -1, name: "Project", code: 0000);

  final dropDownText = ValueNotifier<String>("Project");

  void updateCurrentProject(CurrentProject project) async {
    progressIndicator.loading(text: "Please wait", context: context);

    await currentProjectModel.addProject(project, context);

    Navigator.pop(context);
  }

  void _copyToClipboard(String text) {
    Navigator.pop(context);
    Clipboard.setData(new ClipboardData(text: text));
    customAlert.showAlert(msg: "copied");
  }

  void _shareProject(int code, String project) {
    Navigator.pop(context);
    try {
      Share.share("Hey there! please use the code $code to join my project",
          subject: "Join My Project - $project");
    } catch (e) {
      customAlert.showAlert(isSuccess: false, msg: e);
    }
  }

  final _containerKey = GlobalKey();

  // Project currentProject;
  @override
  void initState() {
    // update current project on signin
    if (projectBox.keys.length > 0 && currentProjectBox.get(0) == null) {
      currentProjectModel.addProject(
          CurrentProject(
              id: projectBox.get(0).id,
              name: projectBox.get(0).name,
              owner: projectBox.get(0).owner,
              code: projectBox.get(0).code),
          context);
    }
    dropDownText.value =
        currentProjectBox.get(0, defaultValue: _defaultProject).name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120.0,
      key: _containerKey,
      decoration: BoxDecoration(
        color: plainWhite,
        boxShadow: [BoxShadow(color: primaryColor)],
      ),
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.menu,
                        color: plainWhite,
                      ),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.account_circle, color: plainWhite),
                      onPressed: () => Navigator.pushNamed(context, "/profile"),
                      padding: EdgeInsets.zero,
                    ),
                  )
                ],
              ),
              ValueListenableBuilder(
                valueListenable: dropDownText,
                builder: (context, value, __) => DropdownButtonHideUnderline(
                  child: SingleChildScrollView(
                    child: ValueListenableBuilder(
                      valueListenable: projectBox.listenable(),
                      builder: (context, _, __) => Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 8, 0),
                        child: DropdownButton<ProjectModel>(
                          isDense: false,
                          iconSize: 35,
                          isExpanded: true,
                          elevation: 4,
                          style: TextStyle().copyWith(
                            color: primaryColor,
                            fontSize: 18,
                          ),
                          // dropdownColor: primaryColor,
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: primaryColor,
                          ),
                          hint: Align(
                            child: Text(dropDownText.value,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                )),
                            alignment: Alignment.centerLeft,
                          ),
                          onChanged: (ProjectModel project) {
                            dropDownText.value = project.name;
                            updateCurrentProject(CurrentProject(
                                id: project.id,
                                code: project.code,
                                owner: project.owner,
                                name: project.name));
                          },
                          items: projectBox.values
                              .map((project) => DropdownMenuItem(
                                    value: project,
                                    child: ListTile(
                                        title: Text(
                                          "${project.name} (${project.code})",
                                          style: TextStyle().copyWith(
                                              color: Colors.black,
                                              fontSize: 20.0),
                                        ),
                                        trailing: PopupMenuButton(
                                          padding: EdgeInsets.zero,
                                          icon: Icon(
                                            Icons.more_vert,
                                            color: Colors.black,
                                          ),
                                          itemBuilder: (context) => [
                                            PopupMenuItem(
                                              child: FlatButton.icon(
                                                  icon: Icon(
                                                    Icons.content_copy,
                                                    color: secondaryColor,
                                                  ),
                                                  label: Text("Copy code"),
                                                  onPressed: () =>
                                                      _copyToClipboard(project
                                                          .code
                                                          .toString())),
                                            ),
                                            PopupMenuItem(
                                              child: FlatButton.icon(
                                                onPressed: () => _shareProject(
                                                    project.code, project.name),
                                                icon: Icon(Icons.share),
                                                label: Text("Share"),
                                              ),
                                            ),
                                            PopupMenuItem(
                                                enabled: currentProjectBox
                                                            .get(0)
                                                            .code ==
                                                        project.code
                                                    ? false
                                                    : true,
                                                child: FlatButton.icon(
                                                    icon: Icon(
                                                      Icons.delete,
                                                      color: red,
                                                    ),
                                                    label: Text("Delete"),
                                                    onPressed: currentProjectBox
                                                                .get(0)
                                                                .code !=
                                                            project.code
                                                        ? () async {
                                                            Navigator.pop(
                                                                context);
                                                            Navigator.pop(
                                                                context);
                                                            await Project()
                                                                .deleteProject(
                                                                    project);
                                                          }
                                                        : null)),
                                          ],
                                        )),
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
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
