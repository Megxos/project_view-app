import 'dart:convert';
import 'package:project_view/models/account.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:path/path.dart';
import 'package:project_view/models/project.dart';
import 'package:project_view/models/user.dart';
import 'package:project_view/ui/custom_alerts.dart';
import 'package:project_view/ui/progress_indicator.dart';
import 'package:flutter/material.dart';

Project project = Project();

class Project {
  final userBox = Hive.box<UserModel>("user");

  final projectBox = Hive.box<ProjectModel>("project");

  final accBox = Hive.box<AccountModel>("account");

  final String baseUrl = "http://projectview.herokuapp.com/api/v1";
  String body;

  // retrieve all user projects fron online database
  Future<Response> getProjects() async {
    String userId = userBox.get(0).userId.toString();
    String token = userBox.get(0).token;

    Response response =
        await get(join(baseUrl, "projects", userId), headers: {"token": token});
    return response;
  }

  // join a friends project using project code
  Future<int> joinProject(code, BuildContext context) async {
    try {
      String token = userBox.get(0).token;
      final String userId = userBox.get(0).userId.toString();

      Response response = await post(join(baseUrl, "projects", "join"),
          headers: {"token": token}, body: {"code": code});
      progressIndicator.loading(context: context, text: "Joining Project");

      if (response.statusCode != 200) {
        final error = json.decode(response.body)["error"];
        customAlert.showAlert(isSuccess: false, msg: error["description"]);
      } else {
        final project = json.decode(response.body)["data"]["project"];
        bool isAMember = false;

        for (int i = 0; i < projectBox.length; i++) {
          if (projectBox.get(i).code == project["code"]) {
            isAMember = true;
          }
        }
        if (!isAMember) {
          projectBox.add(ProjectModel(
              id: project["id"],
              name: project["name"],
              owner: project["owner"],
              code: project["code"]));
          customAlert.showAlert(
              msg: "Successfully joined project ${project["name"]}");
        } else {
          final Response accResponse = await get(
              join(baseUrl, "accounts", userId, project["id"].toString()),
              headers: {"token": token});
          if (accResponse.statusCode == 200) {
            final accBody = jsonDecode(accResponse.body)["data"];
            if (accBody["account"] != null) {
              accBox.put(
                  project["id"],
                  AccountModel(
                      id: accBody["account"]["id"],
                      accBank: accBody["account"]["acc_bank"],
                      accName: accBody["account"]["acc_name"],
                      accNo: accBody["account"]["acc_no"]));
            }
          }
          customAlert.showAlert(
              msg: "You are already a member of ${project["name"]}");
        }
      }
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
      return response.statusCode;
    } catch (e) {
      customAlert.showAlert(isSuccess: false, msg: "Something went wrong");
    }
  }

  // create a new user project
  Future<int> newProject(String name) async {
    Map body = {"name": name, "user_id": userBox.get(0).userId.toString()};

    Response response = await post(join(baseUrl, "projects"),
        headers: {"token": userBox.get(0).token}, body: body);

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body)["data"]["project"];
      projectBox.add(ProjectModel(
          id: data["id"],
          owner: int.parse(data["owner"]),
          code: data["code"],
          name: data["name"]));
    }
    return response.statusCode;
  }

  Future<void> deleteProject(ProjectModel project) async {
    try {
      projectBox.delete(projectBox.keys
          .toList()[projectBox.values.toList().indexOf(project)]);

      final String token = userBox.get(0).token;

      final Response response = await delete(
          join(baseUrl, "projects", "delete", project.id.toString()),
          headers: {"token": token});

      if (response.statusCode != 200) throw Error();
    } catch (e) {
      customAlert.showAlert(isSuccess: false, msg: "Something went wrong");
    }
  }
}
