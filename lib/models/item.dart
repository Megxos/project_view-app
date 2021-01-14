import 'package:hive/hive.dart';

part 'item.g.dart';

@HiveType(typeId: 2)
class ItemModel{
  @HiveField(0)
  int id;
  @HiveField(1)
  String item;
  @HiveField(2)
  String price;
  @HiveField(3)
  int quantity;
  @HiveField(4)
  int project;
  @HiveField(5)
  int status;
  @HiveField(6)
  bool selected;

  ItemModel({ this.id, this.item, this.price, this.quantity, this.status, this.project, this.selected = false });
}