import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:path/path.dart';
import 'package:http/http.dart';
import 'package:project_view/models/user.dart';

final userBox = Hive.box<UserModel>("user");

class Account{
  String baseUrl = "http://project-view-api.herokuapp.com";

  UserModel user = userBox.get(0);

  Future<Response>addAccount(acc_bank, acc_no, acc_name)async{

    final String token = user == null ? "" : user.token;
    final dynamic user_id = user == null ? "" : user.user_id;

    final Map body = {
      "acc_bank": acc_bank,
      "acc_no": acc_no,
      "acc_name": acc_name,
      "user_id": user_id.toString()
    };
    Response response = await post(join(baseUrl, "account"), headers: { "token": token }, body: body );

    return response;
  }

  Future<Response> getAccount()async{

    Response response = await get(join(baseUrl, "account", userBox.get(0).user_id.toString().toString()), headers: { "token": userBox.get(0).token });
    return response;
  }
}