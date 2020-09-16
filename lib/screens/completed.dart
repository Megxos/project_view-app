import 'package:flutter/material.dart';
import 'package:project_view/screens/new_project.dart';
import 'package:project_view/services/project_item.dart';

class Completed extends StatefulWidget {
  @override
  _CompletedState createState() => _CompletedState();
}

List <ProjectItem> items = [
  ProjectItem(item: "Cement", price: 23000, quantity: 2, selected: false),
  ProjectItem(item: "Window", price: 50000, quantity: 10, selected: false),
  ProjectItem(item: "Cement", price: 23000, quantity: 2, selected: false),
  ProjectItem(item: "Window", price: 50000, quantity: 10, selected: false),
  ProjectItem(item: "Cement", price: 23000, quantity: 2, selected: false),
  ProjectItem(item: "Window", price: 50000, quantity: 10, selected: false),
  ProjectItem(item: "Cement", price: 23000, quantity: 2, selected: false),
  ProjectItem(item: "Window", price: 50000, quantity: 10, selected: false),
  ProjectItem(item: "Cement", price: 23000, quantity: 2, selected: false),
  ProjectItem(item: "Window", price: 50000, quantity: 10, selected: false),
  ProjectItem(item: "Cement", price: 23000, quantity: 2, selected: false),
  ProjectItem(item: "Window", price: 50000, quantity: 10, selected: false),
  ProjectItem(item: "Cement", price: 23000, quantity: 2, selected: false),
  ProjectItem(item: "Window", price: 50000, quantity: 10, selected: false),
  ProjectItem(item: "Cement", price: 23000, quantity: 2, selected: false),
  ProjectItem(item: "Window", price: 50000, quantity: 10, selected: false),
];
//MediaQuery.of(context).size.height - topBarHeight - bottomNavHeight - MediaQuery.of(context).padding.top,
class _CompletedState extends State<Completed> {
  int topBarHeight = 90;
  int bottomNavHeight = 67;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            child: DataTable(
              columns: [
                DataColumn(label: Text("Item", textAlign: TextAlign.center, textScaleFactor: 1.3, style: TextStyle(fontWeight: FontWeight.bold),),),
                DataColumn(label: Text("Price", textAlign:TextAlign.center, textScaleFactor: 1.3,style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
                DataColumn(label: Text("Quantity", textAlign:TextAlign.center, textScaleFactor: 1.3,style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
              ],
              rows: List<DataRow>.generate(items.length, (index) => DataRow(
                cells: [
                  DataCell(Text("${items[index].item}")),
                  DataCell(Text("${items[index].price}")),
                  DataCell(Text("${items[index].quantity}"))
                ]
              ))
            ),
          ),
        ),
      ],
    );
  }
}
