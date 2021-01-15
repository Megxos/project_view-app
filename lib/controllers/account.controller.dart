import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:path/path.dart';
import 'package:http/http.dart';
import 'package:project_view/models/current_project.dart';
import 'package:project_view/models/user.dart';
import 'package:project_view/ui/custom_alerts.dart';
import 'package:project_view/models/account.dart';

final userBox = Hive.box<UserModel>("user");
final currentProjectBox = Hive.box<CurrentProject>("current_project");
final accBox = Hive.box<AccountModel>("account");

class Account {
  String baseUrl = "http://projectview.herokuapp.com/api/v1";
  String bankUrl = "http://influencerng.herokuapp.com";

  UserModel user = userBox.get(0);

  Future<Response> addAccount(
      accBank, accNo, accName, bankCode, BuildContext context) async {
    final String token = user == null ? "" : user.token;
    final dynamic userId = user == null ? "" : user.userId;

    final project = currentProjectBox.get(0).id;

    final Map body = {
      "accBank": accBank,
      "acc_no": accNo,
      "acc_name": accName,
      "user_id": userId.toString(),
      "project": project.toString(),
      "bank_code": bankCode
    };
    Response response = await post(join(baseUrl, "accounts"),
        headers: {"token": token}, body: body);

    if (response.statusCode != 201) {
      Navigator.pop(context);
      final error = jsonDecode(response.body)["error"];
      customAlert.showAlert(isSuccess: false, msg: error["description"]);
    } else {
      final data = jsonDecode(response.body)["data"];
      AccountModel account = AccountModel(
        id: data["data"]["acc_id"],
        accName: data["data"]["acc_name"],
        accNo: data["data"]["acc_no"],
        accBank: data["data"]["acc_bank"],
        project: project,
      );
      accBox.put(project, account);

      customAlert.showAlert(msg: data["description"]);
      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, "/home");
    }
    return response;
  }

  Future<Response> getAccount() async {
    Response response = await get(
        join(baseUrl, "accounts", userBox.get(0).userId.toString().toString()),
        headers: {"token": userBox.get(0).token});
    return response;
  }

  Future<void> getAccounts() async {
    UserModel _defaultValue = UserModel(userId: -1, token: "not set");
    final userId = userBox.get(0, defaultValue: _defaultValue).userId;
    final token = userBox.get(0, defaultValue: _defaultValue).token;

    Response response = await get(join(baseUrl, "accounts", userId.toString()),
        headers: {"token": token});
    final body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final List accounts = body["data"]["accounts"];
      for (int i = 0; i < accounts.length; i++) {
        accBox.put(
            accounts[i]["project"],
            AccountModel(
                accNo: accounts[i]["acc_no"],
                accName: accounts[i]["acc_name"],
                accBank: accounts[i]["acc_bank"],
                project: accounts[i]["project"]));
      }
    }
  }

  Future<List> getBanks() async {
    Response response = await get(join(bankUrl, "payment", "banks"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return [];
  }

  Future<Map> verifyAccount(bank, number) async {
    Map body = {"account_bank": bank, "account_number": number};
    Response response =
        await post(join(bankUrl, "payment", "bank", "verify"), body: body);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return {};
  }
}
