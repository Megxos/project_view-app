import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:project_view/models/item.dart';
import 'package:project_view/models/user.dart';
import 'dart:convert';
import 'package:path/path.dart';

Item item = Item();

class Item{
  final String baseUrl = "https://project-view-api.herokuapp.com";

  final userBox = Hive.box<UserModel>("user");

  final itemBox = Hive.box<ItemModel>("item");

  Future<int>getItems(int code)async{
    String token = userBox.get(0).token;

    Response response = await get(join(baseUrl, "item", code.toString()), headers: { "token": token });
    if(response.statusCode == 200){
      final data = jsonDecode(response.body)["data"]["items"];
      itemBox.clear();
      for(int i = 0; i < data.length; i++){
        itemBox.add(ItemModel(
          id: data[i]["id"],
          item: data[i]["item"],
          price: data[i]["price"],
          quantity: data[i]["quantity"]
        ));
      }
      return response.statusCode;
    }else{
      return response.statusCode;
    }
  }

  addItem(ItemModel item)async{
    String token = userBox.get(0).token;
    String user_id = userBox.get(0).user_id.toString();
  }
}