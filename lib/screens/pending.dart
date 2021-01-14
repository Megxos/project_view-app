import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:project_view/controllers/user.controller.dart';
import 'package:project_view/models/account.dart';
import 'package:project_view/models/current_project.dart';
import 'package:project_view/models/item.dart';
import 'package:project_view/models/user.dart';
import 'package:project_view/ui/colors.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Pending extends StatefulWidget {
  @override
  _PendingState createState() => _PendingState();
}

List <ItemModel> rows = [];


class _PendingState extends State<Pending> {

  final userBox = Hive.box<UserModel>("user");

  final accBox = Hive.box<AccountModel>("account");

  final currentProjectBox = Hive.box<CurrentProject>("current_project");

  Box<ItemModel> itemBox = Hive.box<ItemModel>("item");

  final _formkey = GlobalKey<FormState>();
  final itemController = TextEditingController();
  final priceController = TextEditingController();
  final quantityController = TextEditingController();

  @override
  int itemCount = rows.length;
  void getItems(){
    for(int i = 0; i < itemBox.length; i++){
      if(itemBox.getAt(i).project == currentProjectBox.get(0).code){
        setState(() {
          itemCount = itemBox.keys.toList().length ;
        });
      }
    }
  }

  List <ItemModel> selectedItems;

  @override
  void initState() {
    selectedItems = [];
    super.initState();
  }

  //function to add new item
  void addItem(){
    // progressIndicator.Loading(text: "Please wait", context: context);
      itemBox.add(ItemModel(
      item: itemController.text,
      price: priceController.text,
      quantity: int.parse(quantityController.text),
      project: currentProjectBox.get(0).code
    ));
  }

  bool _isSnackbarActive = false;

  bool _showCheckboxColumn  = false;

  //  function to delete selected items
  void deleteSelected()async{
    for(int i = 0; i < selectedItems.length; i++){
      await itemBox.deleteAt(itemBox.values.toList().indexOf(selectedItems[i]));
    }
    _isSnackbarActive = false;
  }

  void markComplete(){
    // for(int i = 0; i < selectedItems.length; i++){
    //   items.insert(0, selectedItems[i]);
    //   rows.removeAt(rows.indexOf(selectedItems[i]));
    //   selectedItems.remove(selectedItems[i]);
    // }
    // setState(() {
    //   _isSnackbarActive = false;
    // });
  }
  double navHeight = kBottomNavigationBarHeight;

  AccountModel _defaultValue = AccountModel(
      acc_bank: "Not set",
      acc_name: "Not set",
      acc_no: "Not set"
  );
  UserModel _defaultUserValue = UserModel(
      email: "Not set",
      firstname: "Not set",
      lastname: "Not set",
      token: "Not set"
  );
  CurrentProject _defaultProject = CurrentProject(
    id: 0,
    owner: -1
  );

  Widget build(BuildContext context) {
    int currentProjectId = currentProjectBox.get(0, defaultValue: _defaultProject).id;
    String acc_bank = accBox.get(currentProjectId, defaultValue: _defaultValue).acc_bank;
    String acc_name = accBox.get(currentProjectId, defaultValue: _defaultValue).acc_name;
    String acc_no = accBox.get(currentProjectId, defaultValue: _defaultValue).acc_no;

    // rows.clear();
    // getItems();

    List <bool> selected = List<bool>.generate(itemCount, (index) => false);

    // function to manage selected items
    final actionSnackBar = SnackBar(
      elevation: 0,
      duration: Duration(days: 1),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text("Select Action")
            ],
          ),
          Row(
            children: [
              FlatButton.icon(
                  onPressed: ()async{
                    await deleteSelected();
                    Scaffold.of(context).hideCurrentSnackBar();
                  },
                  icon: Icon(Icons.delete),
                  label: Text("Delete selected")
              )
            ],
          ),
          Row(
            children: [
              FlatButton.icon(
                  onPressed: (){
                    markComplete();
                    Scaffold.of(context).hideCurrentSnackBar();
                  },
                  icon: Icon(Icons.done),
                  label: Text("Mark as complete")
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FlatButton.icon(
                  onPressed: (){
                    _isSnackbarActive = false;
                    Scaffold.of(context).hideCurrentSnackBar();
                  },
                  icon: Icon(Icons.close),
                  label: Text("Close")
              )
            ],
          ),
        ],
      ),
    );

    // function to select table item
    void selectItem(value, index, ItemModel item){
      item.selected = value;
        setState(() {
          _showCheckboxColumn ? null : _showCheckboxColumn = true;
        });
      if(value && !_isSnackbarActive){
        setState(() {
          selectedItems.add(item);
          _isSnackbarActive = true;
        });
        Scaffold.of(context).showSnackBar(actionSnackBar);
      }
      else if(value && _isSnackbarActive){
       setState(() {
         selectedItems.add(item);
       });
      }
      else if(!value && selectedItems.length > 1){
        setState(() {
          selectedItems.removeAt(selectedItems.indexOf(item));
        });
      }
      else if(!value && selectedItems.length <= 1){
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
        IconButton(icon: Icon(Icons.close, color: Colors.red, size: 40,),onPressed: (){Navigator.pop(context);},),
        IconButton(
          icon: Icon(Icons.done, color: Colors.green, size: 40,),
          onPressed: (){
            if(_formkey.currentState.validate()){
              addItem();
              Navigator.pop(context);
            }
          },
        ),
      ],
      content: Form(
        key: _formkey,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: itemController,
                validator: (value)=> value.length < 3 ? "min of 3 characters" : null,
                maxLength: 25,
                decoration: InputDecoration(
                  counterText: '',
                    hintText: "Cement",
                    labelText: "Item"
                ),
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: priceController,
                keyboardType: TextInputType.number,
                validator: (value){
                  if(value.length < 1 ){
                    return "field is required";
                  }else if(int.parse(value) < 1){
                    return "cannot be 0";
                  }else{
                    return null;
                  }
                },
                decoration: InputDecoration(
                    labelText: "Price",
                    hintText: "5,000"
                ),
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                validator: (value){
                  if(value.length < 1 ){
                    return "field is required";
                  }else if(int.parse(value) < 1){
                    return "cannot be 0";
                  }else{
                    return null;
                  }
                },
                decoration: InputDecoration(
                    hintText: "3",
                    labelText: "Quantity"
                ),
              ),
            ]
        ),
      ),
    );

    // dialog to show donation account details
    final donateDialog = AlertDialog(
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Account details"),
          Divider(color: appAccent,)
        ],
      ),
      content: Stack(
            overflow: Overflow.visible,
            children: [
              Positioned(
                top: -120,
                right: 75,
                child: InkResponse(
                    child: FlatButton(
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                      child: CircleAvatar(
                        child: Icon(Icons.close),
                      ),
                    )
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text("Bank: "),
                      Text(acc_bank, style: TextStyle().copyWith(color: lightGrey),)
                    ],
                  ),
                  Divider(),
                  Row(
                    children: [
                      Text("Account No: "),
                      Text(acc_no, style: TextStyle().copyWith(color: lightGrey),)
                    ],
                  ),
                  Divider(),
                  Row(
                    children: [
                      Text("Account Name: "),
                      Text(acc_name, style: TextStyle().copyWith(color: lightGrey),)
                    ],
                  ),
                ],
              ),
            ]
        )
      );

    return Column(
        children: [
          SizedBox(height: 2.0,),
          GestureDetector(
            onTap: (){
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 40 - 67 - 100 - MediaQuery.of(context).padding.top,
              width: double.infinity,
              child: SingleChildScrollView(
                  child: ValueListenableBuilder(
                    valueListenable: itemBox.listenable(),
                    builder: (context, _, __) {
                      return DataTable(
                      sortColumnIndex: 2,
                      sortAscending: true,
                      showCheckboxColumn: _showCheckboxColumn,
                      dividerThickness: 5,
                      columns: [
                        DataColumn(label: Text("Item", textAlign: TextAlign.center, textScaleFactor: 1.3, style: TextStyle(fontWeight: FontWeight.bold),),),
                        DataColumn(label: Text("Price", textAlign:TextAlign.center, textScaleFactor: 1.3,style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
                        DataColumn(label: Text("Quantity", textAlign:TextAlign.center, textScaleFactor: 1.3,style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
                      ],
                      rows: List<DataRow>.generate(itemBox.keys.toList().length, (index){
                        return DataRow(
                            selected: itemBox.get(index).selected,
                            onSelectChanged: (bool value){
                              selectItem(value, index, itemBox.get(index));
                            },
                            cells: [
                              DataCell(Text("${itemBox.get(index).item}"),),
                              DataCell(Text("${itemBox.get(index).price}")),
                              DataCell(
                                  TextFormField(
                                    initialValue: "${itemBox.get(index).quantity}",
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.right,
                                    decoration: InputDecoration(
                                      filled: false,
                                      contentPadding: EdgeInsets.zero,
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide.none
                                      ),
                                      border: InputBorder.none,
                                    ),
                                    onFieldSubmitted: (val) => {
                                      rows[index].quantity = int.parse(val)
                                    },
                                    style: TextStyle().copyWith(fontSize: 20),
                                  ), showEditIcon: currentProjectBox.get(0).owner == userBox.get(0).user_id)
                              // DataCell(TextFormField(initialValue: "${rows[index].quantity},", keyboardType: TextInputType.number, decoration: InputDecoration(border: InputBorder.none),style: TextStyle().copyWith(fontSize: 15,),), showEditIcon: true, onTap: (){})
                            ]
                        );
                      }),
                    );}
                  )
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
                  builder: (context, Box<CurrentProject> box, _){
                    return currentProjectBox.get(0, defaultValue: _defaultProject).owner ==
                        userBox.get(0, defaultValue: _defaultUserValue).user_id  ?
                    Expanded(child: GestureDetector(
                      child: OutlineButton(
                        onPressed: (){
                          showDialog(context: context, builder: (context)=> itemDialog);
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        ),
                        child: Text("Add New Item", style: TextStyle(color: Colors.indigo[500])),
                        borderSide: BorderSide(color: Colors.indigo[500], width: 3,),
                      ),
                    )
                    ) : Expanded(
                      child: ButtonTheme(
                        child: GestureDetector(
                          child: FlatButton(
                            onPressed: (){
                              showDialog(context: context, builder: (context)=> donateDialog);
                            },
                            child: Text("Make A Donation", style: TextStyle(color: Colors.white),),
                            color: primaryColor,
                            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 8.0),
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        ),
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
    );
  }
}
