import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:project_view/controllers/account.controller.dart';
import 'package:project_view/controllers/project.controller.dart';
import 'package:project_view/models/account.dart';
import 'package:project_view/models/project.dart';
import 'package:project_view/models/user.dart';
import 'dart:convert';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:project_view/ui/colors.dart';
import 'package:project_view/ui/progress_indicator.dart';
import 'package:project_view/ui/custom_alerts.dart';

final userBox = Hive.box<UserModel>("user");
final Account account = Account();

final accBox = Hive.box<AccountModel>("account");

final projectBox = Hive.box<ProjectModel>("project");

class User{
  final String baseUrl = "https://projectview.herokuapp.com/api/v1";

  String token = userBox.get(0) == null ? "" : userBox.get(0).token;
  String user_id = userBox.get(0) == null ? "" : userBox.get(0).user_id.toString();

  Future<void>  login(email, password, BuildContext context)async{
    try{
      Response response = await post(join(baseUrl, "signin"), body: {"email": email, "password": password} );
      Map body = jsonDecode(response.body);
      if(response.statusCode != 200){
        Navigator.pop(context);
        customAlert.showAlert(isSuccess: false, msg: body["error"]["description"]);
      }else{
        final Map data = jsonDecode(response.body)["data"]["user"];

        UserModel newUser = UserModel(
            email: data["email"],
            user_id: data["user_id"],
            firstname: data["firstname"] == null ? "Not set" : data["firstname"],
            lastname: data["lastname"] == null? "Not set" : data["lastname"],
            token: data["token"]
        );
        await userBox.clear();
        userBox.put(0, newUser);

        Navigator.pop(context);

        progressIndicator.Loading(text: "Preparing Projects", context: context);

        Response projectResponse = await project.getProjects();
        if(projectResponse.statusCode != 200){

          final error = jsonDecode(projectResponse.body)["error"];

          Navigator.pop(context);
          customAlert.showAlert(isSuccess: false, msg: error["description"]);
        }

        final projects = jsonDecode(projectResponse.body)["data"]["projects"];

        await projectBox.clear();

        for(int i = 0; i < projects.length; i++){
          await projectBox.add(ProjectModel(
              id: projects[i]["id"],
              name: projects[i]["name"],
              owner: projects[i]["owner"],
              code: projects[i]["code"]
          ));
        }
        await account.getAccounts();
        Navigator.pop(context);
        Navigator.pushNamed(context, "/home");
      }
    }catch(e){
      Navigator.pop(context);
      customAlert.showAlert(isSuccess: false, msg: "Something went wrong");
    }
  }

  Future <void> signup(email, password, BuildContext context) async{
    try{
      Response response = await post(join(baseUrl, "signup"), body: { "email": email, "password": password });

      final Map data = jsonDecode(response.body);

      if(response.statusCode == 201){
        final newUser = data["data"]["user"];
        userBox.clear();
        userBox.add(UserModel(
          user_id: newUser["user_id"],
          firstname: newUser["firstname"],
          lastname: newUser["lastname"],
          token: newUser["token"],
          email: newUser["email"],
        ));
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, "/home");
      }else{
        Navigator.pop(context);
        customAlert.showAlert(isSuccess: false, msg: data["error"]["description"]);
      }
    }catch(e){
      Navigator.pop(context);
      customAlert.showAlert(isSuccess: false, msg: "Something went wrong");
    }
  }

  Future<Response>updateProfile(firstname, lastname, BuildContext context)async{
    try{

      Map body = {
        "firstname": firstname,
        "lastname": lastname
      };

      Response response = await put(join(baseUrl, "users", "update", user_id), headers: { "token": token },body: body);

      return response;
    }catch(e){
      Navigator.pop(context);
      customAlert.showAlert(isSuccess: false, msg: "Something went wrong");
    }
  }
}