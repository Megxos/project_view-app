import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:project_view/models/account.dart';
import 'package:project_view/models/current_project.dart';
import 'package:project_view/models/item.dart';
import 'package:project_view/models/user.dart';
import 'package:project_view/ui/colors.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:project_view/controllers/item.controller.dart';

class Pending extends StatefulWidget {
  @override
  _PendingState createState() => _PendingState();
}

List<ItemModel> rows = [];

class _PendingState extends State<Pending> {
  final userBox = Hive.box<UserModel>("user");

  final accBox = Hive.box<AccountModel>("account");

  final currentProjectBox = Hive.box<CurrentProject>("current_project");

  Box<ItemModel> itemBox = Hive.box<ItemModel>("item");

  final _formkey = GlobalKey<FormState>();
  final itemController = TextEditingController();
  final priceController = TextEditingController();
  final quantityController = TextEditingController();
  final int itemCount = rows.length;
  List<ItemModel> selectedItems;

  @override
  void initState() {
    selectedItems = [];
    super.initState();
  }

  //function to add new item
  void addItem() async {
    // progressIndicator.Loading(text: "Please wait", context: context);
    setState(() {
      _isLoading = true;
    });
    final ItemModel newItem = ItemModel(
        item: itemController.text,
        price: priceController.text,
        quantity: int.parse(quantityController.text),
        project: currentProjectBox.get(0).code);
    await item.addItem(newItem, context);
    setState(() {
      _isLoading = false;
    });
  }

  bool _isSnackbarActive = false;

  bool _showCheckboxColumn = false;

  bool _isLoading = false;

  //  function to delete selected items
  void deleteSelected() async {
    _isSnackbarActive = false;
    _showCheckboxColumn = false;
    // list of item ids
    final List<int> items =
        List.generate(selectedItems.length, (index) => selectedItems[index].id);

    // list of item keys
    final keys = List.generate(
        selectedItems.length,
        (index) => itemBox.keys
            .toList()[itemBox.values.toList().indexOf(selectedItems[index])]);

    await itemBox.deleteAll(keys);

    selectedItems.clear();

    await item.deleteItems(items);
  }

  void markComplete() async {
    final List<int> ids =
        List.generate(selectedItems.length, (index) => selectedItems[index].id);
    item.markComplete(selectedItems);
    _isSnackbarActive = false;
    _showCheckboxColumn = false;
    await item.syncComplete(ids);
    selectedItems.clear();
  }

  double navHeight = kBottomNavigationBarHeight;

  AccountModel _defaultValue =
      AccountModel(accBank: "Not set", accName: "Not set", accNo: "Not set");
  UserModel _defaultUserValue = UserModel(
      email: "Not set",
      firstName: "Not set",
      lastName: "Not set",
      token: "Not set");
  CurrentProject _defaultProject = CurrentProject(id: 0, owner: -1);

  Widget build(BuildContext context) {
    int currentProjectId =
        currentProjectBox.get(0, defaultValue: _defaultProject).id;
    String accBank =
        accBox.get(currentProjectId, defaultValue: _defaultValue).accBank;
    String accName =
        accBox.get(currentProjectId, defaultValue: _defaultValue).accName;
    String accNo =
        accBox.get(currentProjectId, defaultValue: _defaultValue).accNo;

    // function to manage selected items
    final actionSnackBar = SnackBar(
      elevation: 0,
      duration: Duration(days: 1),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [Text("Select Action")],
          ),
          Row(
            children: [
              FlatButton.icon(
                  onPressed: () async {
                    deleteSelected();
                    Scaffold.of(context).hideCurrentSnackBar();
                  },
                  icon: Icon(Icons.delete),
                  label: Text("Delete selected"))
            ],
          ),
          Row(
            children: [
              FlatButton.icon(
                  onPressed: () {
                    markComplete();
                    Scaffold.of(context).hideCurrentSnackBar();
                  },
                  icon: Icon(Icons.done),
                  label: Text("Mark as complete"))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FlatButton.icon(
                  onPressed: () {
                    _isSnackbarActive = false;
                    Scaffold.of(context).hideCurrentSnackBar();
                  },
                  icon: Icon(Icons.close),
                  label: Text("Close"))
            ],
          ),
        ],
      ),
    );

    // function to select table item
    void selectItem(value, ItemModel item) {
      item.selected = value;
      if (_showCheckboxColumn == false) {
        setState(() {
          _showCheckboxColumn = true;
        });
      }
      if (value && !_isSnackbarActive) {
        setState(() {
          selectedItems.add(item);
          _isSnackbarActive = true;
        });
        Scaffold.of(context).showSnackBar(actionSnackBar);
      } else if (value && _isSnackbarActive) {
        setState(() {
          selectedItems.add(item);
        });
      } else if (!value && selectedItems.length > 1) {
        setState(() {
          selectedItems.removeAt(selectedItems.indexOf(item));
        });
      } else if (!value && selectedItems.length <= 1) {
        Scaffold.of(context).hideCurrentSnackBar();
        setState(() {
          selectedItems.remove(item);
          _isSnackbarActive = false;
          _showCheckboxColumn = false;
        });
      }
    }

    // dialog to add new item
    final itemDialog = AlertDialog(
      scrollable: true,
      title: Text("Add New Item"),
      actions: [
        IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.red,
            size: 40,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        IconButton(
          icon: Icon(
            Icons.done,
            color: Colors.green,
            size: 40,
          ),
          onPressed: () {
            if (_formkey.currentState.validate()) {
              addItem();
              Navigator.pop(context);
            }
          },
        ),
      ],
      content: Form(
        key: _formkey,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextFormField(
            autofocus: true,
            controller: itemController,
            validator: (value) =>
                value.length < 3 ? "min of 3 characters" : null,
            maxLength: 20,
            maxLengthEnforced: true,
            decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.never,
                counterText: '',
                hintText: "Cement",
                labelText: "Item"),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: priceController,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value.length < 1) {
                return "field is required";
              } else if (int.parse(value) < 1) {
                return "cannot be 0";
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
              labelText: "Price",
              hintText: "5,000",
              floatingLabelBehavior: FloatingLabelBehavior.never,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: quantityController,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value.length < 1) {
                return "field is required";
              } else if (int.parse(value) < 1) {
                return "cannot be 0";
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
              hintText: "3",
              labelText: "Quantity",
              floatingLabelBehavior: FloatingLabelBehavior.never,
            ),
          ),
        ]),
      ),
    );

    // dialog to show donation account details
    final donateDialog = AlertDialog(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Account details"),
            Divider(
              color: appAccent,
            )
          ],
        ),
        content: Stack(overflow: Overflow.visible, children: [
          Positioned(
            top: -120,
            right: 75,
            child: InkResponse(
                child: FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: CircleAvatar(
                child: Icon(Icons.close),
              ),
            )),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text("Bank: "),
                  Text(
                    accBank,
                    style: TextStyle().copyWith(color: lightGrey),
                  )
                ],
              ),
              Divider(),
              Row(
                children: [
                  Text("Account No: "),
                  Text(
                    accNo,
                    style: TextStyle().copyWith(color: lightGrey),
                  )
                ],
              ),
              Divider(),
              Row(
                children: [
                  Text("Account Name: "),
                  Text(
                    accName,
                    style: TextStyle().copyWith(color: lightGrey),
                  )
                ],
              ),
            ],
          ),
        ]));
    int _bottomNavHeight = 67;
    int _appBarHeight = 120;
    return Container(
      height: MediaQuery.of(context).size.height -
          _bottomNavHeight -
          _appBarHeight -
          MediaQuery.of(context).padding.top,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: RefreshIndicator(
                displacement: 0,
                onRefresh: () {
                  Future<void> refresh() async {
                    await item.getItems(currentProjectBox.get(0).code, context);
                  }

                  return refresh();
                },
                child: ValueListenableBuilder(
                  valueListenable: itemBox.listenable(),
                  builder: (context, _, __) {
                    return Stack(alignment: Alignment.center, children: [
                      _isLoading ? CircularProgressIndicator() : SizedBox(),
                      SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                              showCheckboxColumn: _showCheckboxColumn,
                              dividerThickness: 3,
                              showBottomBorder: true,
                              headingTextStyle: TextStyle().copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[800]),
                              columns: [
                                DataColumn(
                                  label: Text(
                                    "Item",
                                    textAlign: TextAlign.center,
                                    textScaleFactor: 1.3,
                                  ),
                                ),
                                DataColumn(
                                    label: Text(
                                      "Price",
                                      textAlign: TextAlign.center,
                                      textScaleFactor: 1.3,
                                    ),
                                    numeric: true),
                                DataColumn(
                                    label: Text(
                                      "Quantity",
                                      textAlign: TextAlign.center,
                                      textScaleFactor: 1.3,
                                    ),
                                    numeric: true),
                              ],
                              rows: itemBox.values
                                  .map((e) => DataRow(
                                          selected: e.selected,
                                          onSelectChanged: (bool value) {
                                            selectItem(value, e);
                                          },
                                          cells: [
                                            DataCell(
                                              Text("${e.item}"),
                                            ),
                                            DataCell(Text("${e.price}")),
                                            DataCell(
                                                TextFormField(
                                                  initialValue: "${e.quantity}",
                                                  keyboardType:
                                                      TextInputType.number,
                                                  textAlign: TextAlign.right,
                                                  decoration: InputDecoration(
                                                    filled: false,
                                                    contentPadding:
                                                        EdgeInsets.zero,
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide
                                                                    .none),
                                                    border: InputBorder.none,
                                                  ),
                                                  onFieldSubmitted: (val) {
                                                    e.quantity = int.parse(val);
                                                    item.updateItem(e.id, val);
                                                  },
                                                  style: TextStyle()
                                                      .copyWith(fontSize: 20),
                                                ),
                                                showEditIcon: currentProjectBox
                                                        .get(0)
                                                        .owner ==
                                                    userBox.get(0).userId)
                                          ]))
                                  .toList()),
                        ),
                      )
                    ]);
                  },
                ),
              ),
            ),
          ),
          SizedBox(
            height: 40,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
              child: Row(
                children: [
                  ValueListenableBuilder(
                    valueListenable: currentProjectBox.listenable(),
                    builder: (context, Box<CurrentProject> box, _) {
                      return currentProjectBox
                                  .get(0, defaultValue: _defaultProject)
                                  .owner ==
                              userBox
                                  .get(0, defaultValue: _defaultUserValue)
                                  .userId
                          ? Expanded(
                              child: GestureDetector(
                              child: OutlineButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => itemDialog);
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0)),
                                child: Text("Add New Item",
                                    style:
                                        TextStyle(color: Colors.indigo[500])),
                                borderSide: BorderSide(
                                  color: Colors.indigo[500],
                                  width: 3,
                                ),
                              ),
                            ))
                          : Expanded(
                              child: ButtonTheme(
                                child: GestureDetector(
                                  child: FlatButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, "/profile");
                                    },
                                    child: Text(
                                      "Make A Donation",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    color: primaryColor,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 8.0),
                                  ),
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0)),
                                buttonColor: Colors.indigo[500],
                              ),
                            );
                    },
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
