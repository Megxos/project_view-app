import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:project_view/controllers/project.controller.dart';
import 'package:project_view/models/item.dart';
import 'package:project_view/models/user.dart';
import 'dart:convert';
import 'package:path/path.dart';
import 'package:project_view/ui/progress_indicator.dart';

Item item = Item();

class Item{
  final String baseUrl = "https://projectview.herokuapp.com/api/v1";

  final userBox = Hive.box<UserModel>("user");

  final itemBox = Hive.box<ItemModel>("item");

  Future<int>getItems(int code)async{
    String token = userBox.get(0).token;

    Response response = await get(join(baseUrl, "items", code.toString()), headers: { "token": token });
    if(response.statusCode == 200){
      final data = jsonDecode(response.body)["data"]["items"];
      itemBox.clear();
      for(int i = 0; i < data.length; i++){
        itemBox.add(ItemModel(
          id: data[i]["id"],
          item: data[i]["item"],
          price: data[i]["price"],
          quantity: data[i]["quantity"],
          project: data[i]["project"]
        ));
      }
      return response.statusCode;
    }else{
      return response.statusCode;
    }
  }

  addItem(ItemModel item, BuildContext context)async{
    String token = userBox.get(0) == null ? "" : userBox.get(0).token;
    String user_id = userBox.get(0) == null ? "" : userBox.get(0).user_id.toString();

    Map body = {
      "user_id": user_id,
      "item": item.item,
      "price": item.price,
      "quantity": item.quantity.toString(),
      "project": item.project.toString()
    };

    Response response = await post(join(baseUrl, "items"), headers: {"token": token}, body: body);
    if(response.statusCode == 201){
      Map data = jsonDecode(response.body)["data"]["item"];

      itemBox.add(ItemModel(
        id: data["id"],
        item: data["item"],
        price: data["price"],
        quantity: int.parse(data["quantity"]),
        project: int.parse(data["project"]),
      ));
      print(response.body);
    }
    Navigator.pop(context);
  }
}