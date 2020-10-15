import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:project_view/models/user.dart';
import 'dart:convert';
import 'package:path/path.dart';

final userBox = Hive.box<UserModel>("user");

String token;
String user_id;

init(){
  if(userBox.get(0) != null){
    token = userBox.get(0).token;
    user_id = userBox.get(0).user_id.toString();
  }
}

class User{
  final String baseUrl = "https://project-view-api.herokuapp.com";

  Future <Response> login(email, password)async{
    Response response = await post(join(baseUrl, "signin"), body: {"email": email, "password": password} );

    return response;
  }

  Future <Response> signup(email, password) async{
    Response response = await post(join(baseUrl, "signup"), body: { "email": email, "password": password });
    final Map data = jsonDecode(response.body);

    return response;
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