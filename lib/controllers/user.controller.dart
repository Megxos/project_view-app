import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:project_view/models/user.dart';
import 'dart:convert';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:project_view/ui/colors.dart';
import 'package:project_view/ui/progress_indicator.dart';

final userBox = Hive.box<UserModel>("user");

class User{
  final String baseUrl = "https://project-view-api.herokuapp.com";

  String token = userBox.get(0) == null ? "" : userBox.get(0).token;
  String user_id = userBox.get(0) == null ? "" : userBox.get(0).user_id.toString();

  Future <Response> login(email, password)async{
    Response response = await post(join(baseUrl, "signin"), body: {"email": email, "password": password} );

    return response;
  }

  Future <int> signup(email, password, BuildContext context) async{
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
      Navigator.pushReplacementNamed(context, "/account");
    }else{
      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: data["error"]["description"],
        gravity: ToastGravity.TOP,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: red,
        fontSize: 20.0,
      );
    }
    return response.statusCode;
  }

  Future<Response>updateProfile(firstname, lastname)async{

    Map body = {
      "firstname": firstname,
      "lastname": lastname
    };

    Response response = await put(join(baseUrl, "user", "update", user_id), headers: { "token": token },body: body);

    return response;
  }
}