import 'package:hive/hive.dart';
part 'completed.g.dart';

@HiveType(typeId: 6)
class CompletedItem {
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
  @HiveField(6)
  bool selected;

  CompletedItem(
      {this.id,
      this.item,
      this.price,
      this.quantity,
      this.project,
      this.selected = false});
}
