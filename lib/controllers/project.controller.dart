import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project_view/ui/colors.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:path/path.dart';
import 'package:project_view/models/project.dart';
import 'package:project_view/models/user.dart';
import 'package:project_view/ui/progress_indicator.dart';
import 'package:flutter/material.dart';

Project project = Project();

class Project{
  final userBox = Hive.box<UserModel>("user");

  final projectBox = Hive.box<ProjectModel>("project");

  final String baseUrl = "http://project-view-api.herokuapp.com";
  String body;

  // retrieve all user projects fron online database
  Future<Response> getProjects()async{
    String user_id = userBox.get(0).user_id.toString();
    String token = userBox.get(0).token;

    Response response = await get(join(baseUrl, "project", user_id), headers: { "token": token });
    return response;
  }

  // join a friends project using project code
  Future<int> joinProject(code, BuildContext context)async{

    String token = userBox.get(0).token;

    Response response = await post(join(baseUrl, "project", "join"), headers: { "token": token },body: { "code": code });
    progressIndicator.Loading(context: context, text: "Joining Project");

    if(response.statusCode != 200){
      final error = json.decode(response.body)["error"];
      Fluttertoast.showToast(
          msg: error["description"],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          backgroundColor: red,
          fontSize: 20
      );
    }
    else {
      final project = json.decode(response.body)["data"]["project"];
      bool isAMember = false;

      for(int i = 0; i < projectBox.length; i++){
        if(projectBox.get(i).code == project["code"]){
          isAMember = true;
        }
      }

      if(!isAMember){
        projectBox.add(ProjectModel(
            id: project["id"],
            name: project["name"],
            owner: project["owner"],
            code: project["code"]
        ));
        Fluttertoast.showToast(
          msg: "Successfully joined project ${project["name"]}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          backgroundColor: green,
          fontSize: 20,
        );
      }else{
        Fluttertoast.showToast(
          msg: "You are already a member of ${project["name"]}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          backgroundColor: green,
          fontSize: 20,
        );
      }
      }
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
    return response.statusCode;
  }

  // create a new user project
  Future<int>newProject(String name)async{
    Map body = {
      "name": name,
      "user_id": userBox.get(0).user_id.toString()
    };

    Response response = await post(join(baseUrl, "project"), headers: { "token": userBox.get(0).token }, body: body);

    if(response.statusCode == 201){
      final data = jsonDecode(response.body)["data"]["project"];
      projectBox.add(ProjectModel(
        id: data["id"],
        owner: int.parse(data["owner"]),
        code: data["code"],
        name: data["name"]
      ));
      return response.statusCode;
    }else{
      return response.statusCode;
    }
    print(response.body);
  }
}