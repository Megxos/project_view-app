import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:project_view/models/completed.dart';
import 'package:project_view/models/item.dart';
import 'package:project_view/models/user.dart';
import 'dart:convert';
import 'package:path/path.dart';
import 'package:project_view/ui/custom_alerts.dart';

Item item = Item();

class Item {
  final userBox = Hive.box<UserModel>("user");

  final itemBox = Hive.box<ItemModel>("item");

  final completedItemBox = Hive.box<CompletedItem>("completed");

  final String baseUrl = "https://projectview.herokuapp.com/api/v1";

  Future<int> getItems(int code, BuildContext context) async {
    try {
      String token = userBox.get(0).token;

      Response response = await get(join(baseUrl, "items", code.toString()),
          headers: {"token": token});
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)["data"]["items"];
        await itemBox.clear();
        await completedItemBox.clear();
        for (int i = 0; i < data.length; i++) {
          if (data[i]["status"] == 1) {
            await itemBox.put(
                i,
                ItemModel(
                    id: data[i]["id"],
                    item: data[i]["item"],
                    price: data[i]["price"],
                    quantity: data[i]["quantity"],
                    project: data[i]["project"]));
          } else {
            await completedItemBox.put(
                i,
                CompletedItem(
                    id: data[i]["id"],
                    item: data[i]["item"],
                    price: data[i]["price"],
                    quantity: data[i]["quantity"],
                    project: data[i]["project"]));
          }
        }
      }
      return response.statusCode;
    } catch (e) {
      customAlert.showAlert(isSuccess: false, msg: "Error fetching items");
    }
  }

  Future<int> addItem(ItemModel item, BuildContext context) async {
    try {
      String token = userBox.get(0) == null ? "" : userBox.get(0).token;
      String userId =
          userBox.get(0) == null ? "" : userBox.get(0).userId.toString();

      Map body = {
        "user_id": userId,
        "item": item.item,
        "price": item.price,
        "quantity": item.quantity.toString(),
        "project": item.project.toString()
      };

      Response response = await post(join(baseUrl, "items"),
          headers: {"token": token}, body: body);
      if (response.statusCode == 201) {
        Map data = jsonDecode(response.body)["data"]["item"];

        itemBox.add(ItemModel(
          id: data["id"],
          item: data["item"],
          price: data["price"],
          quantity: int.parse(data["quantity"]),
          project: int.parse(data["project"]),
        ));
      }
    } catch (e) {
      customAlert.showAlert(isSuccess: false, msg: "You could be offline");
    }
  }

  Future<void> markComplete(ItemModel item, int index) async {
    try {
      final String token = userBox.get(0).token;
      completedItemBox.add(CompletedItem(
          id: item.id,
          item: item.item,
          price: item.price,
          quantity: item.quantity,
          project: item.project));
      itemBox.deleteAt(index);
      await post(join(baseUrl, "items", "complete", item.id.toString()),
          headers: {"token": token});
    } catch (e) {
      customAlert.showAlert(isSuccess: false, msg: "Something went wrong");
    }
  }
}
